class RoleHelper {
  static String getDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'community_head':
        return 'Ketua RT';
      case 'block_leader':
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
