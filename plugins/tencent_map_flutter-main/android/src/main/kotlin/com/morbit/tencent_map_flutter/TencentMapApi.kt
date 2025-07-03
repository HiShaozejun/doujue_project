package com.morbit.tencent_map_flutter

import com.tencent.map.geolocation.TencentLocationManager
import com.tencent.tencentmap.mapsdk.maps.CameraUpdateFactory
import com.tencent.tencentmap.mapsdk.maps.TencentMap.MAP_TYPE_DARK
import com.tencent.tencentmap.mapsdk.maps.TencentMap.MAP_TYPE_NORMAL
import com.tencent.tencentmap.mapsdk.maps.TencentMap.MAP_TYPE_SATELLITE
import com.tencent.tencentmap.mapsdk.maps.TencentMapInitializer
import com.tencent.tencentmap.mapsdk.maps.model.LatLngBounds
import com.tencent.tencentmap.mapsdk.maps.model.PolylineOptions;
import com.tencent.tencentmap.mapsdk.maps.model.LatLng;
import com.tencent.tencentmap.mapsdk.maps.CameraUpdate
import android.util.Log

class TencentMapApi(private val tencentMap: TencentMap) {
  private val mapView = tencentMap.view

  fun updateMapConfig(config: MapConfig) {
    config.mapType?.let {
      mapView.map.mapType = when (it) {
        MapType.NORMAL -> MAP_TYPE_NORMAL
        MapType.SATELLITE -> MAP_TYPE_SATELLITE
        MapType.DARK -> MAP_TYPE_DARK
      }
    }
    config.mapStyle?.let {
      mapView.map.mapStyle = it.toInt()
    }
    config.logoScale?.let { mapView.map.uiSettings.setLogoScale(it.toFloat()) }
    config.logoPosition?.let {
      mapView.map.uiSettings.setLogoPosition(
        it.anchor.toAnchor(),
        intArrayOf(it.offset.y.toInt(), it.offset.x.toInt())
      )
    }
    config.scalePosition?.let {
      mapView.map.uiSettings.setScaleViewPositionWithMargin(
        it.anchor.toAnchor(),
        it.offset.y.toInt(),
        it.offset.y.toInt(),
        it.offset.x.toInt(),
        it.offset.x.toInt()
      )
    }
    config.compassOffset?.let {
      mapView.map.uiSettings.setCompassExtraPadding(
        it.x.toInt(),
        it.y.toInt()
      )
    }
    config.compassEnabled?.let { mapView.map.uiSettings.isCompassEnabled = it }
    config.scaleEnabled?.let { mapView.map.uiSettings.isScaleViewEnabled = it }
    config.scaleFadeEnabled?.let { mapView.map.uiSettings.setScaleViewFadeEnable(it) }
    config.skewGesturesEnabled?.let { mapView.map.uiSettings.isTiltGesturesEnabled = it }
    config.scrollGesturesEnabled?.let { mapView.map.uiSettings.isScrollGesturesEnabled = it }
    config.rotateGesturesEnabled?.let { mapView.map.uiSettings.isRotateGesturesEnabled = it }
    config.zoomGesturesEnabled?.let { mapView.map.uiSettings.isZoomGesturesEnabled = it }
    config.trafficEnabled?.let { mapView.map.isTrafficEnabled = it }
    config.indoorViewEnabled?.let { mapView.map.setIndoorEnabled(it) }
    config.indoorPickerEnabled?.let { mapView.map.uiSettings.isIndoorLevelPickerEnabled = it }
    config.buildingsEnabled?.let { mapView.map.showBuilding(it) }
    config.buildings3dEnabled?.let { mapView.map.setBuilding3dEffectEnable(it) }
    config.myLocationEnabled?.let { mapView.map.isMyLocationEnabled = it }
    config.userLocationType?.let {
      if (mapView.map.isMyLocationEnabled) {
        mapView.map.setMyLocationStyle(it.toMyLocationStyle())
      }
    }
  }

  fun moveCamera(position: CameraPosition, duration: Long) {
    val cameraPosition = position.toCameraPosition(mapView.map.cameraPosition)
    val cameraUpdate = CameraUpdateFactory.newCameraPosition(cameraPosition)
    if (duration > 0) {
      mapView.map.stopAnimation()
      mapView.map.animateCamera(cameraUpdate, duration, null)
    } else {
      mapView.map.moveCamera(cameraUpdate)
    }
  }

  fun moveCameraToRegion(region: Region, padding: EdgePadding, duration: Long) {
    val latLngBounds = region.toLatLngBounds()
    val cameraUpdate = CameraUpdateFactory.newLatLngBoundsRect(
      latLngBounds,
      padding.left.toInt(),
      padding.right.toInt(),
      padding.top.toInt(),
      padding.bottom.toInt(),
    )
    if (duration > 0) {
      mapView.map.stopAnimation()
      mapView.map.animateCamera(cameraUpdate, duration, null)
    } else {
      mapView.map.moveCamera(cameraUpdate)
    }
  }

  fun moveCameraToRegionWithPosition(positions: List<Position?>, padding: EdgePadding, duration: Long) {
    val latLngBounds = LatLngBounds.Builder().include(positions.filterNotNull().map { it.toPosition() }).build()
    val cameraUpdate = CameraUpdateFactory.newLatLngBoundsRect(
      latLngBounds,
      padding.left.toInt(),
      padding.right.toInt(),
      padding.top.toInt(),
      padding.bottom.toInt(),
    )
    if (duration > 0) {
      mapView.map.stopAnimation()
      mapView.map.animateCamera(cameraUpdate, duration, null)
    } else {
      mapView.map.moveCamera(cameraUpdate)
    }
  }

  fun setRestrictRegion(region: Region, mode: RestrictRegionMode) {
    mapView.map.setRestrictBounds(
      region.toLatLngBounds(),
      mode.toRestrictMode()
    )
  }

  fun removeRestrictRegion() {
    mapView.map.setRestrictBounds(null, null)
  }

  fun addMarker(marker: Marker) {
    val tencentMarker = mapView.map.addMarker(marker.toMarkerOptions(tencentMap.binding))
    tencentMap.markers[marker.id] = tencentMarker
    tencentMap.tencentMapMarkerIdToDartMarkerId[tencentMarker.id] = marker.id
  }

  fun removeMarker(id: String) {
    val marker = tencentMap.markers[id]
    if (marker != null) {
      marker.remove()
      tencentMap.markers.remove(id)
      tencentMap.tencentMapMarkerIdToDartMarkerId.remove(marker.id)
    }
  }

  fun addPolylines(lines: List<LatLng>) {
    //Log.d("linda------", "android tmapi addPolylines")
    if (lines.isEmpty()) return

    val polylineOptions = PolylineOptions()
      .addAll(lines)
      .color(0xfff89437.toInt())
      .width(12f)

    try {
      mapView.map.addPolyline(polylineOptions)
      mapView.map.moveCamera(
        CameraUpdateFactory.newLatLngBounds(
          LatLngBounds.Builder().include(lines).build(), 100))
      //Log.d("linda------", "android tmapi addPolylines success")
    }catch (e: Exception) {
      //Log.e("linda------", "绘制 polyline 出错: ${e.message}", e)
    }
  }
  fun updateMarker(markerId: String, options: MarkerUpdateOptions) {
    if (options.position != null) {
      tencentMap.markers[markerId]?.position = options.position.toPosition()
    }
    if (options.alpha != null) {
      tencentMap.markers[markerId]?.alpha = options.alpha.toFloat()
    }
    if (options.rotation != null) {
      tencentMap.markers[markerId]?.rotation = options.rotation.toFloat()
    }
    if (options.zIndex != null) {
      tencentMap.markers[markerId]?.zIndex = options.zIndex.toInt()
    }
    if (options.draggable != null) {
      tencentMap.markers[markerId]?.isDraggable = options.draggable
    }
    if (options.icon != null) {
      options.icon.toBitmapDescriptor(tencentMap.binding)?.let { tencentMap.markers[markerId]?.setIcon(it) }
    }
    if (options.anchor != null) {
      tencentMap.markers[markerId]?.setAnchor(options.anchor.x.toFloat(), options.anchor.y.toFloat())
    }
  }

  fun getUserLocation(): Location {
    return mapView.map.myLocation.toLocation()
  }

  fun start() {
    Log.d("linda--------map onstart","")
    mapView.onStart()
  }

  fun pause() {
    Log.d("linda--------map onpause","")
    mapView.onPause()
  }

  fun resume() {
    Log.d("linda--------map onresume","")
    mapView.onResume()
  }

  fun stop() {
    Log.d("linda--------map stop","")
    mapView.onStop()
  }

  fun destroy() {
    mapView.onDestroy()
  }
}
