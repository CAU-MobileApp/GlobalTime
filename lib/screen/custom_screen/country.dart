import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:searchfield/searchfield.dart';

class Country extends StatefulWidget {
  const Country({
    Key? key,
  }) : super(key: key);

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final focus = FocusNode();
  var _hint = "Search Country";

  @override
  void dispose() {
    _searchController.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);

    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SearchField(
            //https://pub.dev/packages/searchfield 패키지 사용
            suggestions: pvdStore.countryListParsed
                .map((country) => SearchFieldListItem(country,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          country,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )))
                .toList(),
            searchInputDecoration: InputDecoration(
              //input box 관련 ui
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              border: const OutlineInputBorder(),
            ),
            suggestionsDecoration: const BoxDecoration(
              //검색창 리스트 목록 관련 ui
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              color: Colors.white,
            ),
            suggestionItemDecoration: const BoxDecoration(//검색창 리스트 개별 아이템 관련 ui

                ),
            suggestionState: Suggestion.expand,
            textInputAction: TextInputAction.done,
            onSubmit: (value) {
              if (pvdStore.countryListParsed.contains(value) &&
                  value.isNotEmpty) {
                //validity 검사
                pvdStore.setCountry(value); //새로 선택된 지역 정보로 text를 갱신

                if (pvdStore.index == -1) {
                  pvdStoreTheme.getTime(pvdStore.country);
                  pvdStoreTheme.country = value;
                } else {
                  pvdStore.storedThemes[pvdStore.index]
                      .getTime(pvdStore.country);
                  pvdStore.storedThemes[pvdStore.index].country = value;
                }
                _searchController.text = '';
              } else {
                _searchController.text = '';
              }
            },
            hint: _hint,
            focusNode: focus,
            controller: _searchController,
            hasOverlay: false,
            searchStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            maxSuggestionsInViewPort: 5,
            itemHeight: 50,
            onSuggestionTap: (x) {},
          ),
        ),
      ],
    );
  }
}
