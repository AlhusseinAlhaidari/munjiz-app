part of 'service_category_bloc.dart';

abstract class ServiceCategoryEvent extends Equatable {
  const ServiceCategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadServiceCategories extends ServiceCategoryEvent {
  const LoadServiceCategories();

  @override
  List<Object> get props => [];
}

