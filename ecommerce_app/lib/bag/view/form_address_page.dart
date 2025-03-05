import 'package:ecommerce_app/bag/bloc/shipping_address/shipping_address_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form_address/form_address_bloc.dart';



class FormAddressPage extends StatelessWidget {
  const FormAddressPage({super.key, required this.isEditing});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormAddressBloc, FormAddressState>(
  listener: (context, state) {
    if(state is FormAddressSuccess){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu địa chỉ thành công'),
          backgroundColor: Colors.green,
          duration:  Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
      Navigator.of(context).popUntil((route) {
        final context = route.navigator!.context;
        try {
          context.read<ShippingAddressBloc>().add(FetchAddress());
          return true;
        } catch (_) {
          return false;
        }
      });
    }
  },
  child: Scaffold(
          appBar: AppBar(
            title: Text( isEditing ?'Editing Shipping Address':'Adding Shipping Address'),
          ),
          body: BlocBuilder<FormAddressBloc, FormAddressState>(
  builder: (context, state) {
    if(state is FormAddressInitial){
      return FormAddressView(isEditing:isEditing);
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  },
)
      ),
);
  }
}

class FormAddressView extends StatefulWidget{
  const FormAddressView({super.key, required this.isEditing});
  final bool isEditing;
  @override
  State<FormAddressView> createState() => _FormAddressViewState();
}

class _FormAddressViewState extends State<FormAddressView> {
  final _formKey = GlobalKey<FormState>();

  final receiverController = TextEditingController();

  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.isEditing){
      print('edtting ne');
      final initialAddress = context.read<FormAddressBloc>().initialAddress;
      receiverController.text = initialAddress!.receiverName;
      phoneController.text = initialAddress.phone;
      addressController.text = initialAddress.detailAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        'Receiver Name',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        controller: receiverController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (value){
                          context.read<FormAddressBloc>().add(ReceiverNameChanged(value));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          'Country',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                      width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Viet Nam',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _selectProvince(),
                const SizedBox(height: 16),
                _selectDistrict(),
                const SizedBox(height: 16),
                _selectWard(),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          'Phone',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        controller: phoneController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          context.read<FormAddressBloc>().add(PhoneChanged(value));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        'Address Detail',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Details',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        controller: addressController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (value){
                          context.read<FormAddressBloc>().add(AddressDetailChanged(value));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    BlocBuilder<FormAddressBloc, FormAddressState>(
                      builder: (context, state) {

                        if(state is FormAddressInitial){
                          bool newValue;
                          if(state.isDefault){
                            newValue = false;
                          }else{
                            newValue = true;
                          }
                          return Checkbox(value: state.isDefault, onChanged: (value){
                            value = newValue;
                            context.read<FormAddressBloc>().add(DefaultChanged(newValue));
                          });
                        }
                        return Checkbox(value: false, onChanged: (value){
                          value = true;
                        });
                      },
                    ),
                    const SizedBox(width: 5,),
                    const Text('Use as the shipping address',style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200
                    ),)
                  ],
                ),

                _saveButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context){
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: BlocBuilder<FormAddressBloc, FormAddressState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () {
              context.read<FormAddressBloc>().add(SaveButton());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'SAVE ADDRESS',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _selectProvince() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              'Province',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          BlocBuilder<FormAddressBloc, FormAddressState>(
            builder: (context, state) {
              if (state is FormAddressInitial) {
                final provinces = state.provinces;
                final TextEditingController controller = TextEditingController();
                print("Số lượng provinces: ${provinces.length}");
                // Set the controller text if a province is already selected
                if (state.province != null) {
                  controller.text = state.province!.name;
                }

                return GestureDetector(
                  onTap: () {
                    // Store the current BuildContext that has access to the bloc
                    final currentContext = context;

                    // Show dropdown dialog when tapped
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        String searchQuery = '';

                        return StatefulBuilder(
                          builder: (dialogContext, setState) {
                            // Filter provinces based on search query
                            final filteredProvinces = searchQuery.isEmpty
                                ? provinces
                                : provinces.where((province) => province.name
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                                .toList();

                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: double.maxFinite,
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(dialogContext).size.height * 0.8,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Select Province',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Search box
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search provinces',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // List of provinces
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: filteredProvinces.length,
                                        itemBuilder: (dialogContext, index) {
                                          return ListTile(
                                            title: Text(filteredProvinces[index].name),
                                            onTap: () {
                                              // Update the controller text
                                              controller.text = filteredProvinces[index].name;

                                              // Handle selection - use the original context to access bloc
                                              print('Bạn đã chọn tỉnh: ${filteredProvinces[index].name}');

                                              // Use the stored context that has access to the bloc
                                              currentContext.read<FormAddressBloc>().add(
                                                  SelectProvince(filteredProvinces[index])
                                              );

                                              Navigator.of(dialogContext).pop();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    // Prevent direct text input
                    absorbing: true,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        hintText: 'Tap to select',
                        labelText: state.province != null ? state.province!.name : 'Tap to select',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Roboto'
                      ),
                    ),
                  ),
                );
              }
              // Show loading indicator when provinces are not yet available
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _selectDistrict() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              'District',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          BlocBuilder<FormAddressBloc, FormAddressState>(
            builder: (context, state) {
              if (state is FormAddressInitial) {
                final districts = state.districts;
                final TextEditingController controller = TextEditingController();
                return GestureDetector(
                  onTap: () {
                    final currentContext = context;
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        String searchQuery = '';

                        return StatefulBuilder(
                          builder: (dialogContext, setState) {
                            // Filter provinces based on search query
                            final filteredDistrict = searchQuery.isEmpty
                                ? districts
                                : districts.where((district) => district.name
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                                .toList();

                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: double.maxFinite,
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Select District',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Search box
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search district',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // List of provinces
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: filteredDistrict.length,
                                        itemBuilder: (dialogContext, index) {
                                          return ListTile(
                                            title: Text(filteredDistrict[index].name),
                                            onTap: () {
                                              // Update the controller text and close dialog
                                              controller.text = filteredDistrict[index].name;
                                              // Handle selection
                                              print('Bạn đã chọn huyen: ${filteredDistrict[index].name}');

                                              // You may want to dispatch an event to your bloc here
                                              currentContext.read<FormAddressBloc>().add(
                                                  SelectDistrict(filteredDistrict[index])
                                              );

                                              Navigator.of(dialogContext).pop();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    // Prevent direct text input
                    absorbing: true,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: state.district !=null  ? state.district!.name: 'Tab to select',
                        hintText: 'Tap to select district',
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Roboto'
                      ),
                    ),
                  ),
                );
              }
              // Show loading indicator when provinces are not yet available
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _selectWard() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              'Ward',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          BlocBuilder<FormAddressBloc, FormAddressState>(
            builder: (context, state) {
              if (state is FormAddressInitial) {
                final wards = state.wards;
                final TextEditingController controller = TextEditingController();
                return GestureDetector(
                  onTap: () {
                    final currentContext = context;
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        String searchQuery = '';

                        return StatefulBuilder(
                          builder: (dialogContext, setState) {
                            // Filter provinces based on search query
                            final filteredWards= searchQuery.isEmpty
                                ? wards
                                : wards.where((district) => district.name
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                                .toList();

                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: double.maxFinite,
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Select Ward',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Search box
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search Ward',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // List of provinces
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: filteredWards.length,
                                        itemBuilder: (dialogContext, index) {
                                          return ListTile(
                                            title: Text(filteredWards[index].name),
                                            onTap: () {
                                              // Update the controller text and close dialog
                                              controller.text = filteredWards[index].name;
                                              // Handle selection
                                              print('Bạn đã chọn huyen: ${filteredWards[index].name}');

                                              // You may want to dispatch an event to your bloc here
                                              currentContext.read<FormAddressBloc>().add(
                                                  SelectWard(filteredWards[index])
                                              );

                                              Navigator.of(dialogContext).pop();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    // Prevent direct text input
                    absorbing: true,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: state.ward !=null ?state.ward!.name : 'Tab to select',
                        hintText: 'Tap to select Ward',
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Roboto'
                      ),
                    ),
                  ),
                );
              }
              // Show loading indicator when provinces are not yet available
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
