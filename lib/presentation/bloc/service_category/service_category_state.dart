part of 'service_category_bloc.dart';

abstract class ServiceCategoryState extends Equatable {
  const ServiceCategoryState();

  @override
  List<Object> get props => [];
}

class ServiceCategoryInitial extends ServiceCategoryState {}

class ServiceCategoryLoading extends ServiceCategoryState {}

class ServiceCategoryLoaded extends ServiceCategoryState {
  final List<ServiceCategory> categories;

  const ServiceCategoryLoaded({this.categories = const []});

  @override
  List<Object> get props => [categories];
}

class ServiceCategoryError extends ServiceCategoryState {
  final String message;

  const ServiceCategoryError(this.message);

  @override
  List<Object> get props => [message];
}

