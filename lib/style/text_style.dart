import 'package:flutter/material.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/style/color_palete.dart';

class TranslatedText {
  //botombar
  final String home = GlobalItem.language == 'id' ? "Beranda" : "Home";
  final String content = GlobalItem.language == 'id' ? "Konten" : "Content";
  final String plan = GlobalItem.language == 'id' ? "Rencana" : "Plan";
  final String task = GlobalItem.language == 'id' ? "Tugas" : "Task";
  final String profile = GlobalItem.language == 'id' ? "Profil" : "Profile";

  // final String account = GlobalItem.language == 'id' ? "Akun" : "Account";
  // final String list = GlobalItem.language == 'id' ? "Daftar" : "List";
  // final String posted = GlobalItem.language == 'id' ? "Diposting" : "Posted";
  // final String completed = GlobalItem.language == 'id' ? "Selesai" : "Completed";
  // final String uncompleted = GlobalItem.language == 'id' ? "Belum Selesai" : "Uncompleted";
  final String addContent= GlobalItem.language == 'id' ? "Tambah Konten" : "Add Content";
  final String addPlan = GlobalItem.language == 'id' ? "Tambah Rencana" : "Add Plan";
  final String addTask = GlobalItem.language == 'id' ? "Tambah Tugas" : "Add Task";

  //Header
  final String title = GlobalItem.language == 'id' ? "Judul" : "Title";
  final String caption = GlobalItem.language == 'id' ? "Keterangan" : "Caption";
  final String hashtag= GlobalItem.language == 'id' ? "Hashtag" : "Hashtag";
  final String voiceOT = GlobalItem.language == 'id' ? "Suara Melalui Teks" : "Voice Over Text";
  final String team = GlobalItem.language == 'id' ? "Tim" : "Team";
  final String date = GlobalItem.language == 'id' ? "Tanggal" : "Date";
  final String datePost = GlobalItem.language == 'id' ? "Jadwal Posting" : "Schedule Post";
  final String updatedAt= GlobalItem.language == 'id' ? "Diubah Tanggal" : "Update At";
  final String createdAt = GlobalItem.language == 'id' ? "Dibuat Tanggal" : "Create At";
  final String editFile = GlobalItem.language == 'id' ? "Ubah File" : "Edit File";
  final String attachFile = GlobalItem.language == 'id' ? "Lampirkan File" : "Attach File";
  final String description = GlobalItem.language == 'id' ? "Deskripsi" : "Description";
  final String optional = GlobalItem.language == 'id' ? " (Opsional)" : " (Optional)";
  final String actuator = GlobalItem.language == 'id' ? "Pelaksana Tugas" : "Actuator";
  final String selectedFromTeam = GlobalItem.language == 'id' ? "Pilih dari tim?" : "Select from team?";
  final String selectedUser = GlobalItem.language == 'id' ? "Pilih anggota tim" : "Select team member";
  final String startDate = GlobalItem.language == 'id' ? "Tanggal Mulai" : "Starting Date";
  final String endDate = GlobalItem.language == 'id' ? "Tanggal Selesai" : "Ending Date";
  final String madeBy = GlobalItem.language == 'id' ? "Dibuat Oleh" : "Made By";
  final String theme = GlobalItem.language == 'id' ? "Tema" : "Theme";
  final String language = GlobalItem.language == 'id' ? "Bahasa" : "Language";
  final String dark = GlobalItem.language == 'id' ? "Gelap" : "Dark";
  final String light = GlobalItem.language == 'id' ? "Terang" : "Light";
  final String followSystem = GlobalItem.language == 'id' ? "Ikuti Sistem" : "Follow System";
  final String uMedSos = GlobalItem.language == 'id' ? "Sosial Media Anda" : "Your Social Media";
  final String selectIdea = GlobalItem.language == 'id' ? "Pilih Dari Rencana" : "Select From Plan";
  final String notification = GlobalItem.language == 'id' ? "Notifikasi" : "Notification";
  final String notificationTime = GlobalItem.language == 'id' ? "Waktu Notifikasi" : "Notification Time";
  final String teamNotification = GlobalItem.language == 'id' ? "Notifikasi Tim" : "Team Notification";
  final String contentTL = GlobalItem.language == 'id' ? "Notifikasi Konten" : "Content Notification";
  final String taskTL = GlobalItem.language == 'id' ? "Notifikasi Tugas" : "Task Notification";
  final String timeSet = GlobalItem.language == 'id' ? "Waktu yang Ditetapkan" : "Time Set";
  final String setTime = GlobalItem.language == 'id' ? "Atur Waktu" : "Set Time";
  final String owner = GlobalItem.language == 'id' ? "Pemilik" : "Owner";
  final String addTeam= GlobalItem.language == 'id' ? "Tambah Tim" : "Add Team";
  final String quit = GlobalItem.language == 'id' ? "Keluar" : "Quit";
  final String teamName = GlobalItem.language == 'id' ? "Nama Tim" : "Team Name";
  final String inviteUser = GlobalItem.language == 'id' ? "Undang Pengguna" : "Invite User";
  final String kick = GlobalItem.language == 'id' ? "Keluarkan" : "Kick";
  final String searchUser = GlobalItem.language == 'id' ? "Cari Pengguna" : "Search User";

  //btn
  final String edit = GlobalItem.language == 'id' ? "Ubah" : "Edit";
  final String addFile = GlobalItem.language == 'id' ? "Tambahkan File" : "Add File";
  final String post = GlobalItem.language == 'id' ? "Pos" : "Post";
  final String delete = GlobalItem.language == 'id' ? "Hapus" : "Delete";
  final String save = GlobalItem.language == 'id' ? "Simpan" : "Save";
  final String cancel= GlobalItem.language == 'id' ? "Batal" : "Cancel";
  final String logout = GlobalItem.language == 'id' ? "Keluar" : "Logout";

  //drawer
  final String postedContent= GlobalItem.language == 'id' ? "Konten Diposting" : "Posted Content";
  final String completedTask = GlobalItem.language == 'id' ? "Tugas Selesai" : "Completed Task";
  final String contentCalendar = GlobalItem.language == 'id' ? "Kalender Konten" : "Content Calendar";
  final String teams = GlobalItem.language == 'id' ? "Tim" : "Teams";
  final String settings = GlobalItem.language == 'id' ? "Pengaturan" : "Settings";
  final String logoutConfrim = GlobalItem.language == 'id' ? "Apakah anda ingin keluar?" : "Are you sure you want to log out?";

  //alerts
  final String failEditProfile = GlobalItem.language == 'id' ? "Gagal mengubah profil" : "Failed edit profile";
  final String successEditProfile = GlobalItem.language == 'id' ? "Berhasil mengubah profil" : "Profile edited successfully";
  final String kickMember = GlobalItem.language == 'id' ? "Member tim dikeluarkan" : "Team Member Kicked";
  final String teamDeleted = GlobalItem.language == 'id' ? "Tim telah dihapus" : "Team deleted";
  final String quitFromTeam = GlobalItem.language == 'id' ? "Kamu telah keluar dari tim" : "You quit from this team";
  final String deleteDataTitle = GlobalItem.language == 'id' ? "Hapus Data" : "Delete Data";
  final String deleteDataContent = GlobalItem.language == 'id' ? "Apakah anda ingin menghapus data ini?" : "Do you want to delete this data?";
  
  
  final String successAddTeam = GlobalItem.language == 'id' ? "Tim baru ditambahkan" : "Team added";
  final String failedAddTeam = GlobalItem.language == 'id' ? "Gagal menambahkan tim baru" : "Failed add new team";
  final String successEditTeam = GlobalItem.language == 'id' ? "Tim telah diubah" : "Team edited";
  final String failedEditTeam = GlobalItem.language == 'id' ? "Tim gagal diubah" : "Failed edit team";


  final String teamMember = GlobalItem.language == 'id' ? "Anggota tim" : "Team Member";
  final String successAdd = GlobalItem.language == 'id' ? " ditambahkan" : " added";
  final String failAdd = GlobalItem.language == 'id' ? " gagal ditambahkan" : "Failed add new ";
  final String successDelete = GlobalItem.language == 'id' ? " dihapus" : " deleted";
  final String failDelete = GlobalItem.language == 'id' ? "Pengaturan" : "Hehehehehe";
  // final String Hehehehehe = GlobalItem.language == 'id' ? "Pengaturan" : "Hehehehehe";
  // final String Hehehehehe = GlobalItem.language == 'id' ? "Pengaturan" : "Hehehehehe";

  //notifikasi
}
// ${TranslatedText().}
// TranslatedText().

class StyleText {
  static const String textFontFamily = 'BalooChettan2';

  static const TextStyle formTitle = TextStyle(
    color: ColorPalette.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: textFontFamily,
  );

  static const TextStyle btnText = TextStyle(
    color: ColorPalette.white,
    fontSize: 20,
    fontFamily: textFontFamily,
  );

  static const TextStyle boldBtnText = TextStyle(
    color: ColorPalette.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: textFontFamily,
  );

  static const TextStyle landingTitle = TextStyle(
    color: ColorPalette.secondary,
    fontWeight: FontWeight.bold,
    fontFamily: textFontFamily,
    fontSize: 30,
  );

  static const TextStyle pageTitle = TextStyle(
    color: ColorPalette.white,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontFamily: textFontFamily,
  );

  static const TextStyle formLabelStyle = TextStyle(
    fontFamily: textFontFamily,
  );

  static const TextStyle questionAccount = TextStyle(
    color: ColorPalette.white,
    fontSize: 18,
    fontFamily: textFontFamily,
  );

  static const TextStyle boldQuestionAccount = TextStyle(
    color: ColorPalette.white,
    fontSize: 18,
    fontFamily: textFontFamily,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle listTileTitle = TextStyle(
    color: ColorPalette.white,
    fontFamily: textFontFamily,
    fontSize: 20,
  );

  static const TextStyle listTileSubtitle = TextStyle(
    color: ColorPalette.white,
    fontFamily: textFontFamily,
  );

  static const TextStyle detailTitle = TextStyle(
    color: ColorPalette.black,
    fontWeight: FontWeight.bold,
    fontFamily: textFontFamily,
    fontSize: 20,
  );

  static const TextStyle detailDesc = TextStyle(
    color: ColorPalette.black,
    fontFamily: textFontFamily,
    fontSize: 16,
  );
  
  static const TextStyle verText = TextStyle(
    fontFamily: textFontFamily,
    fontSize: 16,
  );
  
  static TextStyle emailOpacity = TextStyle(
    color: ColorPalette.black.withOpacity(.5),
    fontFamily: textFontFamily,
    fontSize: 16,
  );
}
