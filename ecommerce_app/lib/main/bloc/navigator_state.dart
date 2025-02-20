part of 'navigator_bloc.dart';

class MyNavigatorState  extends Equatable{
  final int selectedIndex;
  const MyNavigatorState({
    this.selectedIndex = 0
  });

  // Sửa phương thức copyWith để sử dụng các named parameters
  MyNavigatorState copyWith({
    int? selectedIndex
  }) {
    return   MyNavigatorState(
        selectedIndex:  selectedIndex ?? this.selectedIndex
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex];
}

