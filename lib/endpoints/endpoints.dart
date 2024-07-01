class Endpoints {
  static String baseURL = "http://10.0.2.2:5000";

  static void setBaseURL(String url) {
    baseURL = 'http://$url';
  }

  static String loginFirebase = "$baseURL/api/auth/login";
  static String logoutFirebase = "$baseURL/api/auth/revoke";
  static String registerCustomerFirebase =
      "$baseURL/api/auth/register-customer";
  static String registerTourGuideFirebase =
      "$baseURL/api/auth/register-tourguide";
  static String refreshToken = "$baseURL/api/auth/refresh-token";
  static String verifToken = "$baseURL/api/auth/verification-token";

  static String location = "$baseURL/api/location";
  static String locationByBookingId = "$baseURL/api/location/readByBookingId";

  static String tourguide = "$baseURL/api/tourguide";
  static String tourguideByRating = "$baseURL/api/tourguide/byRating";
  static String updateTourGuide = "$baseURL/api/tourguide/update";

  static String customer = "$baseURL/api/customer";
  static String updateCustomer = "$baseURL/api/customer/update";

  static String tourplan = "$baseURL/api/tourplan/byIdUser";
  static String postTourplan = "$baseURL/api/tourplan/create";
  static String deleteTourplan = "$baseURL/api/tourplan/delete";

  static String activity = "$baseURL/api/activity/";
  static String postActivity = "$baseURL/api/activity/create";
  static String completeActivity = "$baseURL/api/activity/isDone";
  static String deleteActivity = "$baseURL/api/activity/delete";

  static String booking = "$baseURL/api/booking/byIdUser";
  static String bookingNotTourplan =
      "$baseURL/api/booking/byIdUser/notTourPlan";
  static String bookingHistory = "$baseURL/api/booking/readHistory";
  static String completeBooking = "$baseURL/api/booking/completeBooking";
  static String acceptBooking = "$baseURL/api/booking/acceptBooking";
  static String postBookings = "$baseURL/api/booking/create";

  static String comment = "$baseURL/api/comment/";
  static String postComment = "$baseURL/api/comment/create";

  static String showImage = "$baseURL/static/show_image";
}
