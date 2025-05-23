import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

const String linkServerName = "http://10.0.2.2/user_profile";
const String linkGetItem = "$linkServerName/get_items.php";
const String linkGetItemFavorite = "$linkServerName/getFavorites.php";
const String linkUserProfile = "$linkServerName/getUser_Profile.php";
const String linkSearch2 = "$linkServerName/search2.php";

//getUser_Profile
const String linkgetPassword = "$linkServerName/getPassword.php";
const String linkupdatePassword = "$linkServerName/updatePassword.php";
//http://localhost/user_profile/login.php
const String linkLogIn="$linkServerName/login.php";
const String linkRiskEvaluator =
    "$linkServerName/risk_evaluator.php";
//127.0.0.1
/*const String linkServerName = "http://localhost/user_profile";
// const String linkServerName = "http://10.0.2.2/works/user_profile";

const String linkGetItem = "$linkServerName/get_items.php";
const String linkGetItemFavorite = "$linkServerName/getFavorites.php";
const String linkUserProfile = "$linkServerName/getUser_Profile.php";
const String linkSearch2 = "$linkServerName/search2.php";
const String login = "$linkServerName/login.php";

//getUser_Profile
const String linkgetPassword = "$linkServerName/getPassword.php";
const String linkupdatePassword = "$linkServerName/updatePassword.php";
//http://localhost/user_profile/login.php
const String linkLogIn = "$linkServerName/login.php";
const String linkRiskEvaluator = "$linkServerName/risk_evaluator.php";
const String linkGetRiskLevel = "$linkServerName/get_risk_level.php";
const String linkItemDetails = "$linkServerName/iteam_deaiteld_from_dp.php";
const String linkAddProduct = "$linkServerName/add-product.php";
const String linkGetAuction = "$linkServerName/get_auction.php";
const String linkDeleteItem = "$linkServerName/delete.php";
const String linkSaveUser = "$linkServerName/save_user.php";
const String linkGetRecent = "$linkServerName/get-recent.php";
const String linkSendMsg = "$linkServerName/send_msg.php";
const String linkGetUsers = "$linkServerName/get_users.php";
const String linkPlacedBid = "$linkServerName/placed_Bid.php";
const String linkAddFavorite = "$linkServerName/addfavorite.php";

// other
const String emulator = "http://192.168.88.2/auction";
const String linkUserStatus = "$emulator/user_status.php";
*/
String getBaseUrl() {
  if (kIsWeb) {
    return 'http://127.0.0.1'; // Web
  } else if (Platform.isAndroid) {
    return 'http://10.0.2.2'; // Android emulator
  } else {
    return 'http://127.0.0.1'; // iOS or desktop
  }
}
