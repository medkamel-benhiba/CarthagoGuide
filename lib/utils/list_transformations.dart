import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class ListTransformations {

  static Matrix4 getMonumentTransformMatrix(TransformableListItem item) {
    const endScaleBound = 0.8;

    final animationProgress = item.visibleExtent / item.size.height;

    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

      paintTransform.translate(item.size.width / 2);
      paintTransform.scale(scale);
      paintTransform.translate(-item.size.width / 2);

      final rotation = (1 - animationProgress) * 0.01;
      if (item.position == TransformableListItemPosition.bottomEdge) {
        paintTransform.rotateX(-rotation);
      } else if (item.position == TransformableListItemPosition.topEdge) {
        paintTransform.rotateX(rotation);
      }
    }

    return paintTransform;
  }
}