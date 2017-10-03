/// Provides the various values of available user privileges, and helper functions to aid in comparing them/
abstract class APrivilegeSet {
  static const String none = "none";
  static const String authenticated = "authenticated";
  static const String admin = "admin"; // Implies all other privileges
  final List<String> privileges;

  APrivilegeSet(this.privileges);

  /// Determines whether the privilege that is [needed] is satisfied by the privilege the user [has].
  bool evaluate(String needed, String has) {
    if (needed == none) return true;
    if (has == admin) return true;

    if (!privileges.contains(needed))
      throw new Exception("User privilege $needed not recognized");
    if (!privileges.contains(has))
      throw new Exception("User privelege $has not recognized");
    return privileges.indexOf(needed) <= privileges.indexOf(has);
  }
}
