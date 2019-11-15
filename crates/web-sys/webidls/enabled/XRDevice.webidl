/* -*- Mode: IDL; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/*
 * WebXR Device API
 * W3C Working Draft, 21 May 2019
 * The origin of this IDL file is:
 * https://www.w3.org/TR/2019/WD-webxr-20190521/
 */

/*
 * Moved to Navigator.webidl
 *partial interface Navigator {
 *[SecureContext, SameObject] readonly attribute XR xr;
 *};
*/

[SecureContext, Exposed=Window] interface XR : EventTarget {
  // Methods
  Promise<void> supportsSession(XRSessionMode mode);
  Promise<XRSession> requestSession(XRSessionMode mode);

  // Events
  attribute EventHandler ondevicechange;
};

enum XRSessionMode {
  "inline",
  "immersive-vr",
  "immersive-ar"
};

enum XREnvironmentBlendMode {
  "opaque",
  "additive",
  "alpha-blend",
};

[SecureContext, Exposed=Window] interface XRSession : EventTarget {
  // Attributes
  readonly attribute XREnvironmentBlendMode environmentBlendMode;
  [SameObject] readonly attribute XRRenderState renderState;
  [SameObject] readonly attribute XRSpace viewerSpace;

  // Methods
  void updateRenderState(optional XRRenderStateInit state);
  Promise<XRReferenceSpace> requestReferenceSpace(XRReferenceSpaceType type);

  FrozenArray<XRInputSource> getInputSources();

  long requestAnimationFrame(XRFrameRequestCallback callback);
  void cancelAnimationFrame(long handle);

  Promise<void> end();

  // Events
  attribute EventHandler onblur;
  attribute EventHandler onfocus;
  attribute EventHandler onend;
  attribute EventHandler onselect;
  attribute EventHandler oninputsourceschange;
  attribute EventHandler onselectstart;
  attribute EventHandler onselectend;
};

dictionary XRRenderStateInit {
  double depthNear;
  double depthFar;
  double inlineVerticalFieldOfView;
  XRLayer? baseLayer;
  XRPresentationContext? outputContext;
};

[SecureContext, Exposed=Window] interface XRRenderState {
  readonly attribute double depthNear;
  readonly attribute double depthFar;
  readonly attribute double? inlineVerticalFieldOfView;
  readonly attribute XRLayer? baseLayer;
  readonly attribute XRPresentationContext? outputContext;
};

callback XRFrameRequestCallback = void (DOMHighResTimeStamp time, XRFrame frame);

[SecureContext, Exposed=Window] interface XRFrame {
  [SameObject] readonly attribute XRSession session;

  XRViewerPose? getViewerPose(XRReferenceSpace referenceSpace);
  XRPose? getPose(XRSpace sourceSpace, XRSpace destinationSpace);
};

[SecureContext, Exposed=Window] interface XRSpace : EventTarget {
  
};

enum XRReferenceSpaceType {
  "identity",
  "position-disabled",
  "eye-level",
  "floor-level",
  "bounded",
  "unbounded"
};

[SecureContext, Exposed=Window]
interface XRReferenceSpace : XRSpace {
  XRReferenceSpace getOffsetReferenceSpace(XRRigidTransform originOffset);

  attribute EventHandler onreset;
};

[SecureContext, Exposed=Window]
interface XRBoundedReferenceSpace : XRReferenceSpace {
  readonly attribute FrozenArray<DOMPointReadOnly> boundsGeometry;
};    

enum XREye {
  "left",
  "right"
};

[SecureContext, Exposed=Window] interface XRView {
  readonly attribute XREye eye;
  [SameObject] readonly attribute Float32Array projectionMatrix;
  [SameObject] readonly attribute XRRigidTransform transform;
};

[SecureContext, Exposed=Window] interface XRViewport {
  readonly attribute long x;
  readonly attribute long y;
  readonly attribute long width;
  readonly attribute long height;
};

[SecureContext, Exposed=Window,
 Constructor(optional DOMPointInit position, optional DOMPointInit orientation)]
interface XRRigidTransform {
  [SameObject] readonly attribute DOMPointReadOnly position;
  [SameObject] readonly attribute DOMPointReadOnly orientation;
  [SameObject] readonly attribute Float32Array matrix;
  [SameObject] readonly attribute XRRigidTransform inverse;
};

[SecureContext, Exposed=Window,
 Constructor(optional DOMPointInit origin, optional DOMPointInit direction),
 Constructor(XRRigidTransform transform)]
interface XRRay {
  [SameObject] readonly attribute DOMPointReadOnly origin;
  [SameObject] readonly attribute DOMPointReadOnly direction;
  [SameObject] readonly attribute Float32Array matrix;
};

[SecureContext, Exposed=Window] interface XRPose {
  [SameObject] readonly attribute XRRigidTransform transform;
  readonly attribute boolean emulatedPosition;
};

[SecureContext, Exposed=Window] interface XRViewerPose : XRPose {
  // TODO: Use FrozenArray once available. (Bug 1236777)
  // [SameObject] readonly attribute FrozenArray<XRView> views;
  [SameObject, Frozen, Cached, Pure] readonly attribute sequence<XRView> views;
};

enum XRHandedness {
  "none",
  "left",
  "right"
};

enum XRTargetRayMode {
  "gaze",
  "tracked-pointer",
  "screen"
};

[SecureContext, Exposed=Window]
interface XRInputSource {
  readonly attribute XRHandedness handedness;
  readonly attribute XRTargetRayMode targetRayMode;
  [SameObject] readonly attribute XRSpace targetRaySpace;
  [SameObject] readonly attribute XRSpace? gripSpace;
  [SameObject] readonly attribute Gamepad? gamepad;
};

enum GamepadMappingType {
  "",            // Defined in the Gamepad API
  "standard",    // Defined in the Gamepad API
  "xr-standard",
};

[SecureContext, Exposed=Window] interface XRLayer {};

typedef (WebGLRenderingContext or
         WebGL2RenderingContext) XRWebGLRenderingContext;

dictionary XRWebGLLayerInit {
  boolean antialias = true;
  boolean depth = true;
  boolean stencil = false;
  boolean alpha = true;
  boolean ignoreDepthValues = false;
  double framebufferScaleFactor = 1.0;
};

[SecureContext, Exposed=Window, Constructor(XRSession session,
             XRWebGLRenderingContext context,
             optional XRWebGLLayerInit layerInit)]
interface XRWebGLLayer : XRLayer {
  // Attributes
  [SameObject] readonly attribute XRWebGLRenderingContext context;

  // TODO: Had to disable non-SameObject attributes and methods to get bindings
  // (but not sure which of the two is causing problems)
  //readonly attribute boolean antialias;
  //readonly attribute boolean ignoreDepthValues;

  [SameObject] readonly attribute WebGLFramebuffer framebuffer;
  //readonly attribute unsigned long framebufferWidth;
  //readonly attribute unsigned long framebufferHeight;

  // Methods
  //XRViewport? getViewport(XRView view);
  //void requestViewportScaling(double viewportScaleFactor);

  // Static Methods
  //static double getNativeFramebufferScaleFactor(XRSession session);
};

partial dictionary WebGLContextAttributes {
    boolean xrCompatible = null;
};

partial interface mixin WebGLRenderingContextBase {
    Promise<void> makeXRCompatible();
};

[SecureContext, Exposed=Window] interface XRPresentationContext {
  [SameObject] readonly attribute HTMLCanvasElement canvas;
};

[SecureContext, Exposed=Window, Constructor(DOMString type, XRSessionEventInit eventInitDict)]
interface XRSessionEvent : Event {
  [SameObject] readonly attribute XRSession session;
};

dictionary XRSessionEventInit : EventInit {
  required XRSession session;
};

[SecureContext, Exposed=Window, Constructor(DOMString type, XRInputSourceEventInit eventInitDict)]
interface XRInputSourceEvent : Event {
  [SameObject] readonly attribute XRFrame frame;
  [SameObject] readonly attribute XRInputSource inputSource;
  [SameObject] readonly attribute long? buttonIndex;
};

dictionary XRInputSourceEventInit : EventInit {
  required XRFrame frame;
  required XRInputSource inputSource;
  long? buttonIndex = null;
};

[SecureContext, Exposed=Window, Constructor(DOMString type, XRReferenceSpaceEventInit eventInitDict)]
interface XRReferenceSpaceEvent : Event {
  [SameObject] readonly attribute XRReferenceSpace referenceSpace;
  [SameObject] readonly attribute XRRigidTransform? transform;
};

dictionary XRReferenceSpaceEventInit : EventInit {
  required XRReferenceSpace referenceSpace;
  XRRigidTransform transform;
};
