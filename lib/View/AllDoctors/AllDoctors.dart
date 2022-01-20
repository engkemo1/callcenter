import 'dart:ui';
import 'package:e7gz_call_center/Controller/AllDoctors/AllDoctorsController.dart';
import 'package:e7gz_call_center/Model/Notification/PusherNotificationRes.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/View/AllDoctors/AllDoctorsList.dart';
import 'package:e7gz_call_center/View/AllDoctors/AllDoctorsSearchedList.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomHeadersTextWhite.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:e7gz_call_center/View/CustomWidget/LogoContainer.dart';
import 'package:e7gz_call_center/View/MainDrawer.dart';
import 'package:e7gz_call_center/View/Notification/ShowAllNotification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AllDoctors extends GetView<AllDoctorsController> {
  String LOGD = '/AllDoctorsScreen';
  // final AllDoctorsController _controller = Get.put(AllDoctorsController());

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return GetBuilder<AllDoctorsController>(
      init: Get.put(AllDoctorsController()),
      builder: (_controller) {
        return ModalProgressHUD(
          inAsyncCall: _controller.modalHudController.isLoading,
          child: Scaffold(
            drawer: MainDrawer(),
            appBar: AppBar(
              actions: [
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                      // Get.back();
                      Get.to(() => ShowAllNotification());
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: mWidth * 0.03),
                      child: _controller.notificationPusherList.length > 0
                          ? Center(
                              child: myNotification(
                                  _controller.notificationPusherList.length))
                          : Icon(
                              Icons.notifications,
                              color: ConstStyles.BaseBackGround,
                            ),
                    ),
                  ),
                ),
              ],
              title: CustomHeadersTextWhite(Txt: ConstString.AllDoctors),
            ),
            backgroundColor: ConstStyles.HeadersBackGround,
            body: Container(
              padding:
                  EdgeInsets.only(right: mWidth * 0.04, left: mWidth * 0.04),
              width: mWidth,
              child: LayoutBuilder(
                builder: (context, constrains) {
                  var height = constrains.maxHeight;
                  var width = constrains.maxWidth;
                  return Column(
                    // fit: StackFit.expand,
                    children: [
                      //TODO Filters
                      Container(
                        width: width,
                        height: height * 0.4,
                        padding: EdgeInsets.only(top: mHeight * 0.005),
                        child: ListView(
                          children: [
//TODO Government and city
                            Container(
                              width: width,
                              height: height * 0.114,
                              child: Center(
                                child: Row(
                                  children: [
                                    //TODO Choose Government
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ConstStyles.HeadersBackGround,
                                          border: Border.all(
                                              width: width * 0.005,
                                              color: ConstStyles
                                                  .HeadersBackGround)),
                                      width: width * 0.5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: width * 0.39,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: CustomText(
                                                    Txt: ConstString
                                                        .ChooseGovernment,
                                                    size: 16,
                                                    color: ConstStyles
                                                        .BlackBackGround,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: ConstStyles
                                                        .BaseBackGround,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  width: width * 0.4,
                                                  height: height * 0.05,
                                                  child: DropdownButton(
                                                    items: _controller
                                                        .governmentDataList
                                                        .map((appointmentType) {
                                                      return DropdownMenuItem(
                                                          value: appointmentType
                                                              .name,
                                                          child: Container(
                                                            width: width * 0.3,
                                                            child: CustomText(
                                                              Txt:
                                                                  appointmentType
                                                                      .name,
                                                              size: 16,
                                                              color: ConstStyles
                                                                  .BlackBackGround,
                                                            ),
                                                          ));
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      _controller
                                                          .changeSelectedGov(
                                                              value);
                                                    },
                                                    value:
                                                        _controller.selectedGov,
                                                    dropdownColor: ConstStyles
                                                        .TextBackGround,
                                                    icon: Container(
                                                        width: width * 0.09,
                                                        child: Icon(Icons
                                                            .arrow_drop_down_circle)),
                                                    iconEnabledColor:
                                                        ConstStyles
                                                            .ViewsBackGround,
                                                    elevation: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.1,
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons.delete,
                                                color: ConstStyles
                                                    .TimeStatusUnAvailable,
                                              ),
                                              onTap: () {
                                                _controller.clearGov();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //TODO Choose City
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ConstStyles.HeadersBackGround,
                                          border: Border.all(
                                              width: width * 0.005,
                                              color: ConstStyles
                                                  .HeadersBackGround)),
                                      width: width * 0.5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: width * 0.39,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: CustomText(
                                                    Txt: ConstString.ChooseCity,
                                                    size: 16,
                                                    color: ConstStyles
                                                        .BlackBackGround,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: ConstStyles
                                                        .BaseBackGround,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  height: height * 0.05,
                                                  width: width * 0.4,
                                                  child: DropdownButton(
                                                    items: _controller
                                                        .citiesDataList
                                                        .map((appointmentType) {
                                                      return DropdownMenuItem(
                                                          value: appointmentType
                                                              .name,
                                                          child: Container(
                                                            width: width * 0.3,
                                                            child: CustomText(
                                                              Txt:
                                                                  appointmentType
                                                                      .name,
                                                              size: 16,
                                                              color: ConstStyles
                                                                  .BlackBackGround,
                                                            ),
                                                          ));
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      _controller
                                                          .changeSelectedCity(
                                                              value);
                                                    },
                                                    value: _controller
                                                        .selectedCity,
                                                    dropdownColor: ConstStyles
                                                        .TextBackGround,
                                                    icon: Container(
                                                        width: width * 0.09,
                                                        child: Icon(Icons
                                                            .arrow_drop_down_circle)),
                                                    iconEnabledColor:
                                                        ConstStyles
                                                            .ViewsBackGround,
                                                    elevation: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.1,
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons.delete,
                                                color: ConstStyles
                                                    .TimeStatusUnAvailable,
                                              ),
                                              onTap: () {
                                                _controller.clearCity();
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            //TODO Specialist and Date
                            Container(
                              width: width,
                              height: height * 0.114,
                              child: Center(
                                child: Row(
                                  children: [
                                    //TODO Specialist
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ConstStyles.HeadersBackGround,
                                          border: Border.all(
                                              width: width * 0.005,
                                              color: ConstStyles
                                                  .HeadersBackGround)),
                                      width: width * 0.5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: width * 0.39,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: CustomText(
                                                    Txt: ConstString
                                                        .ChooseDepartment,
                                                    size: 16,
                                                    color: ConstStyles
                                                        .BlackBackGround,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: ConstStyles
                                                        .BaseBackGround,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  height: height * 0.05,
                                                  width: width * 0.4,
                                                  child: DropdownButton(
                                                    items: _controller
                                                        .specialistDataList
                                                        .map((appointmentType) {
                                                      return DropdownMenuItem(
                                                          value: appointmentType
                                                              .name,
                                                          child: Container(
                                                            width: width * 0.3,
                                                            child: CustomText(
                                                              Txt:
                                                                  appointmentType
                                                                      .name,
                                                              size: 16,
                                                              color: ConstStyles
                                                                  .BlackBackGround,
                                                            ),
                                                          ));
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      print(
                                                          '$LOGD :: ${value}');
                                                      _controller
                                                          .changeSelectedDep(
                                                              value);
                                                    },
                                                    value:
                                                        _controller.selectedDep,
                                                    dropdownColor: ConstStyles
                                                        .TextBackGround,
                                                    icon: Container(
                                                        width: width * 0.09,
                                                        child: Icon(Icons
                                                            .arrow_drop_down_circle)),
                                                    iconEnabledColor:
                                                        ConstStyles
                                                            .ViewsBackGround,
                                                    elevation: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.1,
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons.delete,
                                                color: ConstStyles
                                                    .TimeStatusUnAvailable,
                                              ),
                                              onTap: () {
                                                _controller.clearDep();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //TODO Date
                                    Container(
                                      width: width * 0.5,
                                      child: Column(
                                        children: [
                                          Center(
                                            child: CustomText(
                                              Txt: ConstString.ChooseDate,
                                              size: 16,
                                              color:
                                                  ConstStyles.BlackBackGround,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: ConstStyles.BaseBackGround,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                CustomText(
                                                  Txt:
                                                      '${_controller.selectedWeekDay}  ${_controller.currentDate}',
                                                  color: ConstStyles
                                                      .BlackBackGround,
                                                ),
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons
                                                        .arrow_drop_down_circle,
                                                    color: ConstStyles
                                                        .ViewsBackGround,
                                                    size: height * 0.045,
                                                  ),
                                                  onTap: () {
                                                    _controller
                                                        .selectDate(context);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            //TODO Search Btn
                            SizedBox(
                              height: height * 0.077,
                              width: width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: height * 0.06,
                                    child: GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: width * 0.05,
                                            right: width * 0.05),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: ConstStyles
                                              .FlatIconBackgroundColor,
                                        ),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              Txt: ConstString.Search,
                                              color: ConstStyles.BaseBackGround,
                                            ),
                                            Icon(
                                              Icons.search,
                                              color: ConstStyles.BaseBackGround,
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        _controller.search();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.06,
                                    child: GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: width * 0.05,
                                            right: width * 0.05),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: ConstStyles
                                              .FlatIconBackgroundColor,
                                        ),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              Txt: ConstString.DeleteAllFilter,
                                              color: ConstStyles.BaseBackGround,
                                            ),
                                            Icon(
                                              Icons.clear,
                                              color: ConstStyles.BaseBackGround,
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        _controller.clearAllFilters();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //TODO Search By Doc Name
                            SizedBox(
                              height: height * 0.003,
                            ),
                            Container(
                              height: height * 0.077,
                              decoration: BoxDecoration(
                                color: ConstStyles.BaseBackGround,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  // _controller.filterSearch(value);
                                  _controller.docSearchName = value;
                                },
                                controller: _controller.searchDoc,
                                decoration: InputDecoration(
                                    labelText: ConstString.SearchByDocNam,
                                    prefixIcon: GestureDetector(
                                        onTap: () {
                                          print(
                                              '$LOGD :VIEW: ${_controller.docSearchName}');
                                          _controller.getDocByName(
                                              _controller.docSearchName);
                                        },
                                        child: Icon(Icons.search)),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //TODO Doctors List
                      RefreshIndicator(
                        onRefresh: () {
                          _controller.allSearchedDocList = null;
                          _controller.docSearchName = null;
                          _controller.searchDoc = TextEditingController();
                          return _controller.getAllDoc(null).then((value) {
                            _controller.allFilteredDocList = value;
                            _controller.filteredDocList =
                                _controller.allFilteredDocList;
                          });
                        },
                        child: Container(
                          color: ConstStyles.HeadersBackGround,
                          width: width,
                          height: height * 0.6,
                          child: GetBuilder<AllDoctorsController>(
                            builder: (_) {
                              if (_controller.allSearchedDocList != null &&
                                  _controller.allSearchedDocList.length > 0) {
                                return AllDoctorsSearchedList(
                                    _controller.allSearchedDocList,
                                    _controller.specialistDataList);
                              } else if (_controller.filteredDocList != null) {
                                return AllDoctorsList(
                                    _controller.filteredDocList,
                                    _controller.specialistDataList);
                              } else {
                                return LogoContainer();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget myNotification(counter) {
    return Stack(
      children: <Widget>[
        Icon(Icons.notifications),
        Positioned(
          right: 0,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: new Text(
              '$counter',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
