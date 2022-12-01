import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class ThemeColor extends StatefulWidget {
  ThemeColor({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeColor> createState() => _ThemeColorState();
}

class _ThemeColorState extends State<ThemeColor> with TickerProviderStateMixin {
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return DefaultTabController(
      length: 2,
      child: Align(
          alignment: Alignment(0.0, 1),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.21,
              decoration: BoxDecoration(color: Colors.white),
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
                          padding: const EdgeInsets.all(5.0),
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            isScrollable: false,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black12),
                            tabs: const [
                              Text(
                                'Text',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Clock',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
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
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SlidePicker(
                          pickerColor: context.watch<Store>().index == -1
                              ? pvdStoreTheme.textColor
                              : pvdStore.storedThemes[pvdStore.index].textColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 5),
                          onColorChanged: (color) {
                            pvdStore.index == -1
                                ? pvdStoreTheme.setTextColor(color)
                                : pvdStore.storedThemes[pvdStore.index]
                                    .setTextColor(color);
                          },
                        ),
                        SlidePicker(
                          pickerColor: context.watch<Store>().index == -1
                              ? pvdStoreTheme.clockColor
                              : pvdStore
                                  .storedThemes[pvdStore.index].clockColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 5),
                          onColorChanged: (color) {
                            pvdStore.index == -1
                                ? pvdStoreTheme.setClockColor(color)
                                : pvdStore.storedThemes[pvdStore.index]
                                    .setClockColor(color);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}