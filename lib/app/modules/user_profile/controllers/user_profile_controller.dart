import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_waste/app/data/constants/colors.dart';
import 'package:dont_waste/app/data/models/food_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dont_waste/app/widgets/custom_comfirmation_dialog.dart';
import 'package:dont_waste/app/widgets/custom_loader_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' hide Trans;
import 'package:flutter/material.dart';

class UserProfileController extends GetxController {

  final fullName = "".obs;
  late FirebaseFirestore firestore;
  final foods = <Food>[].obs;

  Future<void> saveFullName()async {
    //FirebaseAuth.instance.currentUser!.displayName = fullName.value;
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return CustomLoaderDialog();
        // return CustomComfirmationDialog(
        //   onCancel: () {},
        //   onConfirm: () {},
        //   text: "test",
        // );
      },
    );
    await FirebaseAuth.instance.currentUser!.updateDisplayName(fullName.value).then((value) {
    Get.back();
      Get.snackbar(
      "info".tr(),
      "succ_updated".tr(),
      colorText: Colors.white,
      margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
      progressIndicatorBackgroundColor: Colors.green,
      barBlur: 0,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(milliseconds: 2500),

      //instantInit: true,
      //shouldIconPulse: true,
      animationDuration: Duration(milliseconds: 300),
      icon: Icon(
        Icons.done,
        color: Colors.green,
        size: 35,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: yellow1,
    );
    }).catchError((onError){
    Get.back();
    Get.snackbar(
    "error".tr(),
    "err_while_posting".tr(),
    colorText: Colors.white,
    margin: EdgeInsets.fromLTRB(10, 30, 10, 10),

    barBlur: 0,
    dismissDirection: DismissDirection.horizontal,
    duration: Duration(milliseconds: 200),

    //instantInit: true,
    //shouldIconPulse: true,
    animationDuration: Duration(milliseconds: 300),
    icon: Icon(
    Icons.cancel,
    color: red2,
    size: 35,
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: yellow1,
    );
    });
  }

  @override
  void onInit() {
    //print(FirebaseAuth.instance.currentUser!.uid);
    firestore = FirebaseFirestore.instance;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> setFoods()async{
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return CustomLoaderDialog();
        // return CustomComfirmationDialog(
        //   onCancel: () {},
        //   onConfirm: () {},
        //   text: "test",
        // );
      },
    );
    foods.value = await fetchFoods();
    Get.back();
  }

  Future<List<Food>> fetchFoods() async {

    final List<Food> foods = [];
    await firestore.collection("posts").where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      //print(value.size);
      value.docs.forEach((element) {

        final food = Food.fromJson(element.data());
        print("1" + food.title!);
         food.id = element.id;
        //print(food.id);
        foods.add(food);
      });
    });
    return foods;
  }
  Future<void> deletePost(String postId)async{
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return CustomComfirmationDialog(
          onCancel: () {
            Get.back();
          },
          onConfirm: () async{
            Get.back();
            FirebaseFirestore.instance.collection("posts").doc(postId).delete().then((value)async {

              await setFoods();
              Get.snackbar(
                "Info",
                "Post succesfully deleted",
                colorText: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                progressIndicatorBackgroundColor: Colors.green,
                barBlur: 0,
                dismissDirection: DismissDirection.horizontal,
                duration: Duration(milliseconds: 2500),

                //instantInit: true,
                //shouldIconPulse: true,
                animationDuration: Duration(milliseconds: 300),
                icon: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 35,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: yellow1,
              );
              //setState();
            }).catchError((onError){
              Get.snackbar(
                "Error",
                "Unexpected error while deleting: " + onError.toString(),
                colorText: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),

                barBlur: 0,
                dismissDirection: DismissDirection.horizontal,
                duration: Duration(milliseconds: 200),

                //instantInit: true,
                //shouldIconPulse: true,
                animationDuration: Duration(milliseconds: 300),
                icon: Icon(
                  Icons.cancel,
                  color: red2,
                  size: 35,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: yellow1,
              );
            });

          },
          text: "Are you sure to delete your post ?",
        );
      },
    );
  }
  String? getUid(){
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> signOut()async{
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return CustomComfirmationDialog(
          onCancel: () {
            Get.back();
          },
          onConfirm: () async{
            Get.back();
            FirebaseAuth.instance.signOut().then((value)async {
              Get.offAllNamed('/choice-view');
              Get.snackbar(
                "Info",
                "Successfully signed out",
                colorText: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                progressIndicatorBackgroundColor: Colors.green,
                barBlur: 0,
                dismissDirection: DismissDirection.horizontal,
                duration: Duration(milliseconds: 2500),

                //instantInit: true,
                //shouldIconPulse: true,
                animationDuration: Duration(milliseconds: 300),
                icon: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 35,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: yellow1,
              );
              //setState();
            }).catchError((onError){
              Get.snackbar(
                "Error",
                "Unexpected error while signing out: " + onError.toString(),
                colorText: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),

                barBlur: 0,
                dismissDirection: DismissDirection.horizontal,
                duration: Duration(milliseconds: 200),

                //instantInit: true,
                //shouldIconPulse: true,
                animationDuration: Duration(milliseconds: 300),
                icon: Icon(
                  Icons.cancel,
                  color: red2,
                  size: 35,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: yellow1,
              );
            });

          },
          text: "Are you sure to sign out from your account ?",
        );
      },
    );
  }
}
