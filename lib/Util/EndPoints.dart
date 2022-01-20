
class EndPoints {
  static const Url = 'http://api.e7gz.co/api/';
  static const LoginEndPoint = Url +'login';
  static const LogOutEndPoint = Url + 'logout?token=';
  static const GetAllSpecialist = Url + 'specialists?token=';
  static const GetAllGovernment = Url + 'governorates?token=';
  static const GetCitiesByGov = Url + 'citiesFromGov';
  static const GetFilteredDoc = Url + 'filterTimes?token=';
  static const SearchDoc = Url + 'search';
  static const CreateNewAppointment = Url + 'appointments?token=';
  static const GetAvailableTimes = Url + 'dayTimes';
  static const ShowMyAppointments = Url + 'appointments';
  static const EditAppointment = Url + 'appointments';
  static const ShowProfileData = Url + 'callCenter/profile';
  static const EditProfileData = Url + 'callCenter/profile';
  static const GetAllCountries = Url + 'countries?token=';
  //TODO Old
  // static const ImagesUrl = 'https://api.aisent.net';
  //TODO New
  static const ImagesUrl = 'http://api.e7gz.co';
  static const AllNotification = Url + 'allNotify';
  static const ConfirmDayCanceled = Url + 'cancelDayConfirm';
  static const ChatNotification = Url + 'chatNotify';
  static const ChatReceipt = Url + 'receiptChat';
  static const ChatMessages = Url + 'messages';
  static const SendMessage = Url + 'messages';
  static const OldChats =Url + 'chatBoxes';
  static const CloseChat = Url + 'closeChat';
  static const SetReadLastMsg = Url + 'setRead';
}