import 'package:e7gz_call_center/Model/FilteredDoctors/FilteredDocList.dart';
import 'package:e7gz_call_center/Model/Specialist/SpecialistList.dart';
import 'package:e7gz_call_center/Util/ConstString.dart';
import 'package:e7gz_call_center/Util/ConstStyles.dart';
import 'package:e7gz_call_center/Util/EndPoints.dart';
import 'package:e7gz_call_center/View/AllDoctors/CreateAppointment.dart';
import 'package:e7gz_call_center/View/CreateAppointment/CreateAppointmentDetails.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomButton.dart';
import 'package:e7gz_call_center/View/CustomWidget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class AllDoctorsList extends StatelessWidget {
  String LOGD = '/AllDoctorsList';
  List<FilteredDocList> _doctors;
  List<SpecialistList> _specialist;



  AllDoctorsList(this._doctors,this._specialist);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      var height = constrains.maxHeight;
      var width = constrains.maxWidth;
      return ListView.builder(
        itemCount: _doctors.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            margin: EdgeInsets.only(top: height * 0.025),
            padding: EdgeInsets.only(right: width * 0.015,left: width * 0.015),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: ConstStyles.TextBackGround,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TODO Doctor Pic
                        Container(
                          width: width * 0.18,
                          height: height*0.2,
                          margin: EdgeInsets.only(top: height * 0.015),
                          child: _doctors[index].avatar == null ? Icon(Icons.person,size: width * 0.18,color: ConstStyles.ViewsBackGround,)
                              :docPic(EndPoints.ImagesUrl + _doctors[index].avatar),
                        ),
                        SizedBox(width: width * 0.04,),
                        //TODO Doctor Data
                        Container(
                          width: width * 0.53,
                          margin: EdgeInsets.only(top: height * 0.015),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TODO Doctor Name
                              SizedBox(
                                  width: width * 0.53,
                                  child: CustomText(size: 20,Txt: _doctors[index].doctorName,alignText: TextAlign.start,color: ConstStyles.BlackBackGround,)),
                              //TODO Doctor Specialist
                              SizedBox(
                                  width: width * 0.53,
                                  child: CustomText(Txt: getDepartment(_doctors[index].department),alignText: TextAlign.start,size: 15,)),
                              //TODO DoctorPrice
                              SizedBox(
                                  width: width * 0.53,
                                  child: Row(
                                    children: [
                                      CustomText(Txt: ConstString.Price,alignText: TextAlign.start,size: 15,),
                                      CustomText(Txt: _doctors[index].price == null ? '_____':_doctors[index].price.toString(),alignText: TextAlign.center,size: 15,),
                                      CustomText(Txt: ConstString.Pound,alignText: TextAlign.start,size: 15,),
                                    ],
                                  )),
                              //TODO Doctor First Available Time
                              Container(
                                  width: width * 0.53,
                                  child: Row(
                                    children: [
                                      CustomText(Txt: convertTo12Hr(_doctors[index].timeFrom),alignText: TextAlign.start,size: 12,),
                                      CustomText(Txt: ' - ',alignText: TextAlign.start,size: 14,),
                                      CustomText(Txt: convertTo12Hr(_doctors[index].timeTo),alignText: TextAlign.start,size: 12,)
                                    ],
                                  )
                              ),

                            ],
                          ),
                        ),
                      ],
                      ),
                      SizedBox(height: height * 0.02,),
                      //TODO Doctor Address
                      Padding(
                        padding:  EdgeInsets.only(right: width * 0.05),
                        child: CustomText(size: 18,Txt: '${_doctors[index].address},${_doctors[index].city},${_doctors[index].governorate}'),
                      ),
                    ],
                  ),
                ),

                //TODO BTN BookNow and Details
                Container(
                  width: width * 0.22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomButton(text: ConstString.BookNow, onClick: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CreateAppointment(_doctors[index]);
                            });
                      }),
                      CustomButton(text: ConstString.Details, onClick: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CreateAppointmentDetails(_doctors[index]);
                            });
                      }),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    },);
  }

  String convertTo12Hr(time){
    DateTime date = DateFormat("h:mm").parse(time); // think this will work better for you
    // print('$LOGD Time :: ${DateFormat('h:mm').format(date)} ---> $time');
    return DateFormat('h:mm a').format(date);
  }

  String getDepartment(depId){
    for(int i=0 ; i<=_specialist.length ; i++){
      // print('$LOGD DepID --> ${depId}   ,  Specialist --> ${_specialist[i].key}');
      if(depId == _specialist[i].key){
        return _specialist[i].name;
      }
    }

  }

  Widget docPic(url) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator())),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.fill,
                imageScale: 1.0,
                placeholder: kTransparentImage,
                image: url,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
