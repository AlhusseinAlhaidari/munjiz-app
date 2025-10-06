import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/service_category.dart';

part 'service_category_event.dart';
part 'service_category_state.dart';

class ServiceCategoryBloc extends Bloc<ServiceCategoryEvent, ServiceCategoryState> {
  ServiceCategoryBloc() : super(ServiceCategoryInitial()) {
    on<LoadServiceCategories>(_onLoadServiceCategories);
  }

  void _onLoadServiceCategories(LoadServiceCategories event, Emitter<ServiceCategoryState> emit) async {
    emit(ServiceCategoryLoading());
    try {
      // Simulate fetching categories from a repository or API
      await Future.delayed(const Duration(seconds: 1));
      final List<ServiceCategory> categories = [
        ServiceCategory(
          id: '1',
          name: 'تنظيف المنزل',
          nameAr: 'تنظيف المنزل',
          description: 'خدمات تنظيف شاملة للمنزل',
          descriptionAr: 'خدمات تنظيف شاملة للمنزل',
          iconUrl: 'cleaning',
          isActive: true,
        ),
        ServiceCategory(
          id: '2',
          name: 'صيانة كهربائية',
          nameAr: 'صيانة كهربائية',
          description: 'إصلاح وصيانة الأجهزة الكهربائية',
          descriptionAr: 'إصلاح وصيانة الأجهزة الكهربائية',
          iconUrl: 'electrical',
          isActive: true,
        ),
        ServiceCategory(
          id: '3',
          name: 'سباكة',
          nameAr: 'سباكة',
          description: 'إصلاح وصيانة السباكة',
          descriptionAr: 'إصلاح وصيانة السباكة',
          iconUrl: 'plumbing',
          isActive: true,
        ),
        ServiceCategory(
          id: '4',
          name: 'نجارة',
          nameAr: 'نجارة',
          description: 'أعمال النجارة والأثاث',
          descriptionAr: 'أعمال النجارة والأثاث',
          iconUrl: 'carpentry',
          isActive: true,
        ),
        ServiceCategory(
          id: '5',
          name: 'دهان',
          nameAr: 'دهان',
          description: 'دهان الجدران والأسقف',
          descriptionAr: 'دهان الجدران والأسقف',
          iconUrl: 'painting',
          isActive: true,
        ),
        ServiceCategory(
          id: '6',
          name: 'تكييف',
          nameAr: 'تكييف',
          description: 'صيانة وتركيب أجهزة التكييف',
          descriptionAr: 'صيانة وتركيب أجهزة التكييف',
          iconUrl: 'ac',
          isActive: true,
        ),
      ];
      emit(ServiceCategoryLoaded(categories: categories));
    } catch (e) {
      emit(ServiceCategoryError(e.toString()));
    }
  }
}

