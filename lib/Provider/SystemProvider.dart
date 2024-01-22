import 'package:flutter/cupertino.dart';
import '../Repository/SystemRepository.dart';
import '../Widget/parameterString.dart';

enum SystemProviderPolicyStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
  isMoreLoading,
}

class SystemProvider extends ChangeNotifier {
  SystemProviderPolicyStatus _systemProviderPolicyStatus =
      SystemProviderPolicyStatus.initial;

  String errorMessage = '';
  String policy = '';

  get getCurrentStatus => _systemProviderPolicyStatus;

  changeStatus(SystemProviderPolicyStatus status) {
    _systemProviderPolicyStatus = status;
    notifyListeners();
  }

  //get System Policies
  Future getSystemPolicies(String policyType) async {
    try {
      changeStatus(SystemProviderPolicyStatus.inProgress);

      var parameter = {TYPE: policyType};
      var result = await SystemRepository.fetchSystemPolicies(
          parameter: parameter, policyType: policyType);
      policy = result["data"].toString();

      changeStatus(SystemProviderPolicyStatus.isSuccsess);
    } catch (e) {
      errorMessage = e.toString();

      changeStatus(SystemProviderPolicyStatus.isFailure);
    }
  }
}
