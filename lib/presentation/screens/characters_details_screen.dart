import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_bad/business_logic/characters_cubit.dart';
import 'package:breaking_bad/constants/my_colors.dart';
import 'package:breaking_bad/data/models/characters.dart';
import 'package:breaking_bad/data/models/quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getCharactersQuotes(character.charName);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo('Job : ', character.jobs.join(' / ')),
                      buildDivider(288),
                      characterInfo(
                          'Appeared In : ', character.categoryForTwoSeries),
                      buildDivider(220),
                      character.appearanceOfSeasons.isEmpty
                          ? Container()
                          : characterInfo('Seasons : ',
                          character.appearanceOfSeasons.join(' / ')),
                      character.appearanceOfSeasons.isEmpty
                          ? Container()
                          : buildDivider(250),
                      characterInfo('Status : ', character.statusIfDeadOrAlive),
                      buildDivider(264),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : characterInfo('Better Call Saul Seasons : ',
                              character.betterCallSaulAppearance.join(' / ')),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : buildDivider(120),
                      characterInfo('Actor/Actress : ', character.actorName),
                      buildDivider(205),
                      const SizedBox(height: 20,),
                      BlocBuilder<CharactersCubit,CharactersState>(
                          builder: (context,state){
                            return checkIfQuotesAreLoaded(state);
                          }
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 360,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.nickName,
          style: TextStyle(color: MyColors.myWhite),
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
                color: MyColors.myWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: MyColors.myWhite, fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: MyColors.myYellow,
      height: 30.0,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state){
    if(state is QuotesLoaded){
      return displayRandomQuoteOrEmptySpace(state);
    }
    else{
      return showProgressIndicator();
    }
  }
  Widget displayRandomQuoteOrEmptySpace( state){
    List<Quote> quotes=state.quotes;
    if(quotes.length!=0){
      int randomQuoteIndex=Random().nextInt(quotes.length-1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: MyColors.myWhite,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: MyColors.myYellow,
                offset: Offset(0,0),
              ),
            ],
          ),
          child:AnimatedTextKit(
            //default three times
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuoteIndex].quote),
            ],

          ) ,
        ),
      );
    }

    else{
      return  Container();
    }
  }

  Widget showProgressIndicator(){
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }
}
