import 'dart:ui';

import 'package:flutter/material.dart';

class PerspectiveListView extends StatefulWidget {
  const PerspectiveListView(
      {super.key,
      required this.visualizedItems,
      required this.isOpened,
      required this.itemExtent,
      required this.children,
      this.initialIndex = 0,
      this.padding = EdgeInsets.zero,
      this.onTapFrontItem,
      this.onChangeFrontItem,
      this.backItemsShadowColor = Colors.transparent,
      this.enableBackItemsShadow = false,
      required this.controller});

  final List<Widget> children;
  final double? itemExtent;
  final bool isOpened;
  final int? visualizedItems;
  final int initialIndex;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int?>? onTapFrontItem;
  final ValueChanged<int>? onChangeFrontItem;
  final Color backItemsShadowColor;
  final bool enableBackItemsShadow;
  final AnimationController controller;

  @override
  PerspectiveListViewState createState() => PerspectiveListViewState();
}

class PerspectiveListViewState extends State<PerspectiveListView> {
  PageController? _pageController;
  int? _currentIndex;
  double? _pagePercent;
  late Animation<double> _opacityShadowAnimation;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      viewportFraction: 1 / widget.visualizedItems!,
      initialPage: _currentIndex!,
    );

    _opacityShadowAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut));
    _pagePercent = 0.0;
    _pageController!.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!
      ..removeListener(_pageListener)
      ..dispose();
    super.dispose();
  }

  void _pageListener() {
    _currentIndex = _pageController!.page!.floor();
    _pagePercent = (_pageController!.page! - _currentIndex!).abs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          children: [
            //---------------------------------------
            // Perspective Items List
            //---------------------------------------
            Padding(
              padding: widget.padding,
              child: _PerspectiveItems(
                isOpened: widget.isOpened,
                controller: widget.controller,
                generatedItems: widget.visualizedItems! - 1,
                currentIndex: _currentIndex,
                heightItem: widget.itemExtent,
                pagePercent: _pagePercent,
                children: widget.children,
              ),
            ),
            //---------------------------------------
            // Back Items Shadow
            //---------------------------------------
            Positioned.fill(
              bottom: widget.itemExtent,
              child: Visibility(
                visible: !widget.isOpened,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.backItemsShadowColor.withOpacity(.8),
                        widget.backItemsShadowColor.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //---------------------------------------
            // Void Page View
            //---------------------------------------
            IgnorePointer(
              ignoring: widget.isOpened,
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                onPageChanged: widget.onChangeFrontItem?.call,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.children.length,
                itemBuilder: (context, index) {
                  return const SizedBox();
                },
              ),
            ),
            //---------------------------------------
            // On Tap Item Area
            //---------------------------------------
            Positioned.fill(
              top: height - widget.itemExtent!,
              child: GestureDetector(
                onTap: () => widget.onTapFrontItem?.call(_currentIndex),
              ),
            )
          ],
        );
      },
    );
  }
}

class _PerspectiveItems extends StatelessWidget {
  const _PerspectiveItems({
    required this.generatedItems,
    required this.isOpened,
    required this.currentIndex,
    required this.heightItem,
    required this.pagePercent,
    required this.controller,
    required this.children,
  });

  final int generatedItems;
  final bool isOpened;
  final AnimationController controller;
  final int? currentIndex;
  final double? heightItem;
  final double? pagePercent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          fit: StackFit.loose,
          children: [
            //---------------------------------
            // Static Last Item
            //---------------------------------
            if (currentIndex! > (generatedItems - 1))
              _TransformedItem(
                controller: controller,
                heightItem: heightItem,
                factorChange: 1,
                endScale: .5,
                child: children[currentIndex! - generatedItems],
              )
            else
              const SizedBox(),
            //----------------------------------
            // Perspective Items
            //----------------------------------
            for (int index = 0; index < generatedItems; index++)
              (currentIndex! > ((generatedItems - 2) - index))
                  ? _TransformedItem(
                      index: index,
                      controller: controller,
                      heightItem: heightItem,
                      isInRange: true,
                      factorChange: pagePercent,
                      scale: lerpDouble(0.5, 1, (index + 1) / generatedItems),
                      translateY:
                          (height - heightItem!) * (index + 1) / generatedItems,
                      endScale: lerpDouble(0.5, 1, index / generatedItems),
                      endTranslateY:
                          (height - heightItem!) * (index / generatedItems),
                      child: children[
                          currentIndex! - (((generatedItems - 2) - index) + 1)],
                    )
                  : const SizedBox(),
            //---------------------------------
            // Bottom Hide Item
            //---------------------------------

            if (currentIndex! < (children.length - 1))
              _TransformedItem(
                controller: controller,
                heightItem: heightItem,
                factorChange: pagePercent,
                translateY: height + 20,
                endTranslateY: height - heightItem!,
                child: children[currentIndex! + 1],
              )
            else
              const SizedBox(),
          ],
        );
      },
    );
  }
}

class _TransformedItem extends StatefulWidget {
  const _TransformedItem(
      {required this.heightItem,
      required this.child,
      required this.factorChange,
      this.index = 0,
      this.endScale = 1.0,
      this.scale = 1.0,
      this.endTranslateY = 0.0,
      required this.controller,
      this.isVisibilityOn = true,
      this.translateY = 0.0,
      this.isInRange = false});

  final bool isVisibilityOn;
  final Widget child;
  final int index;
  final AnimationController controller;
  final double? heightItem;
  final double? factorChange;
  final double? endScale;
  final double endTranslateY;
  final double translateY;
  final double? scale;
  final bool isInRange;

  @override
  State<_TransformedItem> createState() => _TransformedItemState();
}

class _TransformedItemState extends State<_TransformedItem> {
  late Animation<Offset> _animation;

  @override
  void initState() {
    _animation = Tween<Offset>(
            begin: Offset.zero,
            end: Offset(0, -(widget.translateY) + (widget.index * 5)))
        .animate(widget.controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.topCenter,
      transform: Matrix4.identity()
        ..scale(lerpDouble(widget.scale, widget.endScale, widget.factorChange!))
        ..translate(
            0.0,
            lerpDouble(widget.translateY, widget.endTranslateY,
                widget.factorChange!)!),
      child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            return Visibility(
              visible: widget.isVisibilityOn,
              child: Transform.translate(
                offset:
                    widget.isInRange ? _animation.value : const Offset(0, 0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: widget.heightItem,
                    width: double.infinity,
                    child: widget.child,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
