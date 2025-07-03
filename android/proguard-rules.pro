-optimizationpasses 5 # 代码混淆压缩比，在0~7之间，默认为5，一般不做修改
-dontusemixedcaseclassnames # 混合时不使用大小写混合，混合后的类名为小写
-dontskipnonpubliclibraryclasses # 指定不去忽略非公共库的类
-verbose #产生映射文件，包含有类名->混淆后类名的映射关系
-dontskipnonpubliclibraryclassmembers # 指定不去忽略非公共库的类成员
-dontpreverify # 不做预校验，preverify是proguard的四个步骤之一，加快混淆速度。
-dontoptimize

#保留
-keepattributes *Annotation*,InnerClasses # Annotation
-keepattributes EnclosingMethod #反射
-keepattributes Signature #泛型
-keepattributes SourceFile,LineNumberTable #抛出异常时保留代码行号

# 指定混淆是采用的算法，后面的参数是一个过滤器，这个过滤器是谷歌推荐的算法，一般不做更改
-optimizations !code/simplification/cast,!field/*,!class/merging/*
# 需要保留的公共部分
# 保留四大组件，自定义的Application等，因为其都有可能被外部调用
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Appliction
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View
-keep public class com.android.vending.licensing.ILicensingService
# Keep the BuildConfig
#-keep public class com.bfhd.kmsp.BuildConfig { *; } # todo 包名

# 保留本地native方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}

# ------------support相关--------------------------------------
# 保留support下的所有类及其内部类
# 支持库包含对较新平台版本的引用，链接到较旧的平台版本时不会警告
-keep class android.support.** {*;}
-dontwarn android.support.**
# support-v7-cardview
-keep class android.support.v7.widget.RoundRectDrawable { *;}
# support-v7-appcompat
-keep class androidx.appcompat.app.** { *; }
-keep class androidx.appcompat.widget.** { *; }
-keep public class android.support.v7.widget.** { *; }
-keep public class android.support.v7.internal.widget.** { *; }
-keep public class android.support.v7.internal.view.menu.** { *; }
-keep public class * extends android.support.v4.view.ActionProvider {
    public <init>(android.content.Context);
}
# support-design
-dontwarn android.support.design.**
-keep class android.support.design.** { *; }
-keep interface android.support.design.** { *; }
-keep public class android.support.design.R$* { *; }
# support-v4
-keep class android.support.v4.** { *; }
-keep interface android.support.v4.** { *; }
# 保留继承自v7/v4
-keep public class * extends android.support.v4.**
-keep public class * extends android.support.v7.**
-keep public class * extends android.support.annotation.**


# ------------ui相关--------------------------------------
# 保留R下面的资源
-keep class **.R$* {*;}
-keepclassmembers class **.R$* {
    public static <fields>;
}
-keep public class com.bfhd.kmsp.R$*{ #todo 包名
public static final int *;
}

# 保留在Activity中的方法参数是view的方法，在layout中写的onClick就不会被影响
-keepclassmembers class * extends android.app.Activity{
    public void *(android.view.View);
}
# 保留我们自定义控件（继承自View）不被混淆
-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
# 在视图中保留setter，以便动画仍然可以工作。
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}
# 在Activity中保留可在XML属性onClick中使用的方法
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}
#webview
-keepclassmembers class fqcn.of.javascript.interface.for.webview {
    public *;
}
-keepclassmembers class * extends android.webkit.webViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}
-keepclassmembers class * extends android.webkit.webViewClient {
    public void *(android.webkit.webView, jav.lang.String);
}

-keep public class * extends android.support.design.widget.CoordinatorLayout$Behavior {
  public <init>(android.content.Context, android.util.AttributeSet);
}

# ------------lifecycle--------------------------------------
# LifecycleObserver的空构造函数被proguard认为是未使用的
-keepclassmembers class * implements android.arch.lifecycle.LifecycleObserver {
    <init>(...);
}
# ViewModel的空构造函数被proguard视为未使用
-keepclassmembers class * extends android.arch.lifecycle.ViewModel {
    <init>(...);
}
# 保留生命周期状态和事件枚举值
-keepclassmembers class android.arch.lifecycle.Lifecycle$State { *;}
-keepclassmembers class android.arch.lifecycle.Lifecycle$Event { *;}
# 保持使用@OnLifecycleEvent注释的方法，即使它们似乎未被使用
-keepclassmembers class * {
    @android.arch.lifecycle.OnLifecycleEvent *;
}
-keepclassmembers class * implements android.arch.lifecycle.LifecycleObserver {
    <init>(...);
}

-keep class * implements android.arch.lifecycle.LifecycleObserver {
    <init>(...);
}
-keepclassmembers class android.arch.** { *; }
-keep class android.arch.** { *; }
-dontwarn android.arch.**

# ------------jetpack--------------------------------------
-dontwarn android.databinding.**
-keep class android.databinding.** { *; }
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
}
# BaseRecyclerViewAdapterHelper
-keep class com.chad.library.adapter.** {
*;
}
-keep public class * extends com.chad.library.adapter.base.BaseQuickAdapter
-keep public class * extends com.chad.library.adapter.base.BaseViewHolder
-keepclassmembers public class * extends com.chad.library.adapter.base.BaseViewHolder {
           <init>(android.view.View);
}
# paging 分页
-dontwarn android.arch.paging.DataSource
# Room 数据库
-dontwarn android.arch.persistence.room.**
-keep class android.arch.persistence.room.**{ *;}
-dontwarn androidx.room.**
-keep class androidx.room.**{ *;}


# ------------序列化相关--------------------------------------
# 保留数据实体entity
-keep class com.wintop.android.customer.base.data.** { *; }
-keep class com.wintop.android.customer.base.pay.** { *; }
# 保留枚举类不被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
# 保留Parcelable序列化类不被混淆
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
# 保留Serializable序列化的类不被混淆
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
# 对于带有回调函数的onXXEvent、**On*Listener的，不能被混淆
-keepclassmembers class * {
    void *(**On*Event);
    void *(**On*Listener);
}


#gson
-dontwarn sun.misc.**
-keep class sun.misc.Unsafe { *; }
#-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.examples.android.model.** { <fields>; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken


# retrofit2
# Retrofit does reflection on method and parameter annotations.
# Retrofit会对方法和参数注释进行反射。
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
# 优化时保留服务方法参数。
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}
# 忽略用于构建工具的注释。
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
# 忽略JSR 305注释以嵌入可为空性信息。
-dontwarn javax.annotation.**
# 由NoClassDefFoundError守护 try / catch，仅在类路径上使用。
-dontwarn kotlin.Unit
# 顶级功能，只能由Kotlin使用。
-dontwarn retrofit2.KotlinExtensions
# 使用R8完整模式时，它不会看到Retrofit接口的子类型，因为它们是使用Proxy创建的，
# 并用null替换所有可能的值。明确地保持接口可以防止这种情况。
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>
# RxJava RxAndroid
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
    long producerIndex;
    long consumerIndex;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}


# okhttp3
# 资源加载了相对路径，因此必须保留此类的包。
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
# Animal Sniffer compileOnly依赖项，以确保API与旧版本的Java兼容
-dontwarn org.codehaus.mojo.animal_sniffer.*
# OkHttp平台仅在JVM上使用，并且当Conscrypt依赖性可用时。
-dontwarn okhttp3.internal.platform.ConscryptPlatform


# glide
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

#flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class androidx.lifecycle.** { *; }
-keep @interface com.google.gson.annotations.SerializedName
-keep @interface com.google.gson.annotations.Expose
-keepattributes *Annotation*

# ------------三方厂商--------------------------------------
#极光推
-dontwarn cn.jpush.**
-keep class cn.jpush.** { *; }
-keep class * extends cn.jpush.android.helpers.JPushMessageReceiver { *; }
-dontwarn cn.jiguang.**
-keep class cn.jiguang.** { *; }
#华为推送
-ignorewarnings
-keepattributes Exceptions
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}

#支付宝支付
-keep class com.alipay.android.app.IAlixPay{*;}
-keep class com.alipay.android.app.IAlixPay$Stub{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback$Stub{*;}
-keep class com.alipay.sdk.app.PayTask{ public *;}
-keep class com.alipay.sdk.app.AuthTask{ public *;}
-keep class com.alipay.sdk.app.H5PayCallback {
    <fields>;
    <methods>;
}
-keep class com.alipay.android.phone.mrpc.core.** { *; }
-keep class com.alipay.apmobilesecuritysdk.** { *; }
-keep class com.alipay.mobile.framework.service.annotation.** { *; }
-keep class com.alipay.mobilesecuritysdk.face.** { *; }
-keep class com.alipay.tscenter.biz.rpc.** { *; }
-keep class org.json.alipay.** { *; }
-keep class com.alipay.tscenter.** { *; }
-keep class com.ta.utdid2.** { *;}
-keep class com.ut.device.** { *;}

#腾讯地图
-keepclassmembers class ** {
    public void on*Event(...);
}
-dontwarn  org.eclipse.jdt.annotation.**
-keep class com.tencent.map.geolocation.**{*;}
# sdk版本小于18时需要以下配置, 建议使用18或以上版本的sdk编译
-dontwarn  android.location.Location
-dontwarn  android.net.wifi.WifiManager
-dontnote ct.**
-keepclassmembers class ** {
    public void on*Event(...);
}
-keep class c.t.**{*;}

#腾讯im
-keep class com.tencent.imsdk.** { *; }

#腾讯微信支付混淆
-keep class com.tencent.mm.opensdk.** {
*;
}
-keep class com.tencent.wxop.** {
*;
}
-keep class com.tencent.mm.sdk.** {
*;
}
#腾讯vod
-keep class com.tencent.** { *; }
-keep class com.bfhd.flutter_vod.videoupload.** { *; }

#高德地图
#3d地图
-keep class com.amap.api.mapcore.**{*;}
-keep class com.amap.api.maps.**{*;}
-keep class com.autonavi.amap.mapcore.*{*;}
#定位
-keep class com.amap.api.location.**{*;}
-keep class com.loc.**{*;}
-keep class com.amap.api.fence.**{*;}
-keep class com.autonavi.aps.amapapi.model.**{*;}
# 搜索
-keep class com.amap.api.services.**{*;}
# 2D地图
-keep class com.amap.api.maps2d.**{*;}
-keep class com.amap.api.mapcore2d.**{*;}
# 导航
-keep class com.amap.api.navi.**{*;}
-keep class com.autonavi.**{*;}


# 百度人脸离线采集
-keep class com.baidu.vis.unified.license.** {*;}
-keep class com.baidu.liantian.** {*;}
-keep class com.baidu.baidusec.** {*;}
-keep class com.baidu.idl.main.facesdk.** {*;}
##-libraryjars libs/facesdk.jar
-dontwarn com.baidu.idl.facesdk.FaceInfo
-dontwarn com.baidu.idl.facesdk.FaceSDK
-dontwarn com.baidu.idl.facesdk.FaceTracker
-dontwarn com.baidu.idl.facesdk.FaceVerifyData
-keep class com.baidu.idl.facesdk.FaceInfo { *; }
-keep class com.baidu.idl.facesdk.FaceSDK { *; }
-keep class com.baidu.idl.facesdk.FaceTracker { *; }
-keep class com.baidu.idl.facesdk.FaceVerifyData { *; }
-keep class com.baidu.** {*;}
-keep class vi.com.** {*;}
-dontwarn com.baidu.**

#友盟统计
-keep class com.umeng.** {*;}
-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}

##bugly
#-dontwarn com.tencent.bugly.**
#-keep public class com.tencent.bugly.**{*;}

#sharesdk
-keep class cn.sharesdk.**{*;}
-keep class com.sina.**{*;}
-keep class com.mob.**{*;}
-keep class com.bytedance.**{*;}
-dontwarn cn.sharesdk.**
-dontwarn com.sina.**
-dontwarn com.mob.**

