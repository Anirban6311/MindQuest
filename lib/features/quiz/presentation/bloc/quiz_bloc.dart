import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stream/features/quiz/data/repositories/quiz_repos.dart';

import '../../data/models/quiz_data_model.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  late final QuizRepository _quizRepository = QuizRepository();
  QuizBloc() : super(QuizInitial()) {
    on<QuizEvent>(quizEvent);
    on<LoadQuizEvent>(loadQuizEvent);
    on<SelectAnsEvent>(selectAnsEvent);
    on<NextQuesEvent>(nextQuesEvent);
    on<RestartQuizEvent>(restartQuizEvent);
    on<SkipQuesEvent>(skipQuesEvent);
  }

  FutureOr<void> quizEvent(QuizEvent event, Emitter<QuizState> emit) {}
  FutureOr<void> loadQuizEvent(
      LoadQuizEvent event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final quizData = await _quizRepository.fetchQuizData();
      emit(QuizLoaded(
          questions: quizData.results ?? [], currentIndex: 0, score: 0));
    } catch (e) {
      emit(QuizError(errorMessage: "$e"));
    }
  }

  FutureOr<void> selectAnsEvent(SelectAnsEvent event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;

      final currentQuestion = currentState.questions[currentState.currentIndex];
      bool isCorrect = (event.selectedAnswer == currentQuestion.correctAnswer);
      emit(QuizAnsChecked(isCorrect: isCorrect, quizState: currentState));
    }
  }

  FutureOr<void> nextQuesEvent(NextQuesEvent event, Emitter<QuizState> emit) {
    if (state is QuizAnsChecked) {
      final checkedState = state as QuizAnsChecked;
      final currentState = checkedState.quizState;

      //iterate over the quiz questions
      if (currentState.currentIndex < currentState.questions.length - 1) {
        emit(QuizLoaded(
            questions: currentState.questions,
            currentIndex: currentState.currentIndex + 1,
            score: checkedState.isCorrect
                ? currentState.score + 1
                : currentState.score));
      } else {
        final checkedState = state as QuizAnsChecked;
        final int totalScore = checkedState.quizState.score;
        emit(QuizCompleted(

            ///total scored might cause error
            totalScored: totalScore,
            totalAnswered: currentState.questions.length));
      }
    }
  }

  FutureOr<void> restartQuizEvent(
      RestartQuizEvent event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final quizData = await _quizRepository.fetchQuizData();
      emit(QuizLoaded(
          questions: quizData.results ?? [], currentIndex: 0, score: 0));
    } catch (e) {
      emit(QuizError(errorMessage: "$e"));
    }
  }

  FutureOr<void> skipQuesEvent(SkipQuesEvent event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentIndex < currentState.questions.length - 1) {
        emit(QuizLoaded(
            questions: currentState.questions,
            currentIndex: currentState.currentIndex + 1,
            score: currentState.score));
      } else if (currentState.currentIndex ==
          currentState.questions.length - 1) {
        final currentState = state as QuizLoaded;
        final int totalScore = currentState.score;
        emit(QuizCompleted(
            totalScored: totalScore,
            totalAnswered: currentState.questions.length));
      }
    } else {
      emit(const QuizError(errorMessage: "Cannot skip to other question"));
    }
  }
}
