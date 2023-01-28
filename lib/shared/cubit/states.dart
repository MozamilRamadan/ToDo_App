abstract class AppStates {}

class AppInitialStates extends AppStates {}

class AppBottomNavBar extends AppStates {}
class AppQueryData extends AppStates {}

class AppUpdateData extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}

//===================CreateDataBase=========================
class AppCreateDatabaseState extends AppStates {}
class AppCreateDatabaseSuccessState extends AppStates {}
class AppCreateDatabaseErrorState extends AppStates {}
//====================InsertIntoDatabase=====================
class AppInsertToDatabaseState extends AppStates {}
class AppInsertToDatabaseSuccessState extends AppStates {}
class AppInsertToDatabaseErrorState extends AppStates {}
//====================GetFromDatabase========================
class AppGetFromDatabaseLoadingState extends AppStates {}
class AppGetFromDatabaseSuccessState extends AppStates {}
class AppGetFromDatabaseErrorState extends AppStates {}
//====================================================
class AppDeleteFromDatabaseLoadingState extends AppStates {}
class AppDeleteFromDatabaseSuccessState extends AppStates {}
class AppDeleteFromDatabaseErrorState extends AppStates {}

class AppUpdateDatabaseState extends AppStates {}
