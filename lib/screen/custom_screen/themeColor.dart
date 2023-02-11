import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class ThemeColor extends StatefulWidget {
  const ThemeColor({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeColor> createState() => _ThemeColorState();
}

class _ThemeColorState extends State<ThemeColor> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return DefaultTabController(
      length: 2,
      child: Align(
          alignment: const Alignment(0.0, 1),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.black12,
                      width: 4,
                    ))),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            isScrollable: false,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black12),
                            tabs: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text(
                                  'Text',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text(
                                  'Clock',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SlidePicker(
                          pickerColor: context.watch<Store>().index == -1
                              ? pvdStoreTheme.textColor
                              : pvdStore.storedThemes[pvdStore.index].textColor,
                          onColorChanged: (color) {
                            pvdStore.index == -1
                                ? pvdStoreTheme.setTextColor(color)
                                : pvdStore.storedThemes[pvdStore.index]
                                    .setTextColor(color);
                          },
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 15),
                          showIndicator: false,
                          sliderSize: const Size(250, 30),
                        ),
                        SlidePicker(
                          pickerColor: context.watch<Store>().index == -1
                              ? pvdStoreTheme.clockColor
                              : pvdStore
                                  .storedThemes[pvdStore.index].clockColor,
                          onColorChanged: (color) {
                            pvdStore.index == -1
                                ? pvdStoreTheme.setClockColor(color)
                                : pvdStore.storedThemes[pvdStore.index]
                                    .setClockColor(color);
                          },
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          showIndicator: false,
                          sliderSize: const Size(250, 30),
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}
