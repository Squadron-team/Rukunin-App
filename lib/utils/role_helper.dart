class RoleHelper {
  static String getDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'ketua_rt':
        return 'Ketua RT';
      case 'ketua_rw':
        return 'Ketua RW';
      case 'secretary':
        return 'Sekretaris';
      case 'treasurer':
        return 'Bendahara';
      case 'resident':
      default:
        return 'Warga';
    }
  }
}
