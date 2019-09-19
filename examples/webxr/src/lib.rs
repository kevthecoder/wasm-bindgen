use wasm_bindgen::prelude::*;
use wasm_bindgen::JsCast;
use web_sys::{Navigator, XR, XRSession};

#[wasm_bindgen(start)]
pub fn start() -> Result<(), JsValue> {
    let document = web_sys::window().unwrap().document().unwrap();
    let navigator: web_sys::Navigator = web_sys::window().unwrap().navigator();
    let xr: web_sys::XR = navigator.xr;
    let xr: web_sys::XR = navigator.xr();
    Ok(())
}
