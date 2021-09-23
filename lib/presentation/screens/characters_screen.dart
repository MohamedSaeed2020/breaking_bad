import 'package:breaking_bad/business_logic/characters_cubit.dart';
import 'package:breaking_bad/constants/my_colors.dart';
import 'package:breaking_bad/data/models/characters.dart';
import 'package:breaking_bad/presentation/widgets/characters_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        leading: _isSearching
            ? BackButton(
                color: MyColors.myGrey,
              )
            : null,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body:buildBlocWidget(),
      /*OfflineBuilder(
        connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child)
        {
          final bool connected=connectivity!=ConnectivityResult.none;
          if(connected){
            return buildBlocWidget();
          }
          else{
            return _buildNoInternetWidget();
          }
        },
        child: showLoadingIndicator(),
      ),*/
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = state.characters;
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty
          ? allCharacters.length
          : searchedCharacters.length,
      itemBuilder: (context, index) {
        return CharacterItem(
          character: _searchTextController.text.isEmpty
              ? allCharacters[index]
              : searchedCharacters[index],
        );
      },
    );
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  ///************** SECOND PART (SEARCHING) *****************

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        ),
      ];
    }
  }

  void _startSearch() {
    //make the back arrow
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    _isSearching = true;
  }

  void _stopSearching() {
    _clearSearch();
    _isSearching = false;
  }

  void _clearSearch() {
      _searchTextController.clear();
  }

  Widget _buildAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(
        color: MyColors.myGrey,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        hintText: 'Find a Character',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: MyColors.myGrey,
          fontSize: 18.0,
        ),
      ),
      style: TextStyle(
        color: MyColors.myGrey,
        fontSize: 18.0,
      ),
      onChanged: (searchedCharacter) {
        _addSearchedItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void _addSearchedItemsToSearchedList(String searchedCharacter) {
    searchedCharacters = allCharacters
        .where((character) =>
            character.charName.toLowerCase().startsWith(searchedCharacter))
        .toList();
    // TODO why setState[1?
    setState(() {});
  }

  Widget _buildNoInternetWidget(){
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Text(
              "Can't connect.. check internet",
              style: TextStyle(
                fontSize: 22,
                color: MyColors.myGrey,
              ),
            ),
            Image.asset('assets/images/no_internet.png'),
          ],
        ),
      ),
    );
  }
}
