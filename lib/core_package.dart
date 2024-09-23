library core_package;

import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:math' as math;

import 'package:core_package/store/login_store/login_store.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:xxtea/xxtea.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:validators/validators.dart';
import 'package:flutter/foundation.dart';

//apple
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//facebook
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

//google
import 'package:google_sign_in/google_sign_in.dart';

//LinkedIn
import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

//CustomLogin
import 'package:intl_phone_field/intl_phone_field.dart';

//OTP
import 'package:telephony/telephony.dart';

//sizemixin
part 'utils/mixins/size_mixin.dart';

//Custom login
part 'custom_login/social_login/apple_login/apple_login.dart';
part 'custom_login/social_login/facebook_login/facebook_login.dart';
part 'custom_login/social_login/google_login/google_login.dart';
part 'custom_login/social_login/linkedin_login/linkedin_login.dart';
part 'custom_login/custom_login_main/custom_login.dart';
part 'custom_login/otp_setup/otp_setup.dart';
part 'custom_login/otp_setup/timer_mixin.dart';

//local data
part 'global/core_local_data/core_local_data.dart';
part 'global/user_local_data/user_local_data.dart';
part 'global/global_context/global_context.dart';

//module
part 'module/local_module/local_module.dart';
part 'module/network_module/network_modeule.dart';

//model
part 'model/app_data/app_data.dart';
part 'model/rest_response/rest_response.dart';

//dio
part 'src/dio_client_network.dart';
part 'utils/dio_err_util/dio_err_util.dart';
part 'utils/mixins/message_service_mixin.dart';

//data source
part 'src/data_source_main.dart';
part 'utils/encryption/encryption.dart';

//custom services
part 'services/base/base_service.dart';
part 'services/startup_service/startup_service.dart';
part 'services/logout_service/logout_service.dart';
part 'services/login_service/login_services.dart';
