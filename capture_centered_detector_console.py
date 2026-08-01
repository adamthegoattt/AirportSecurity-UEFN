import unreal

camera = unreal.Vector(120.0, -2250.0, 330.0)
target = unreal.Vector(710.0, -1770.0, 205.0)
rotation = unreal.MathLibrary.find_look_at_rotation(camera, target)
unreal.EditorLevelLibrary.set_level_viewport_camera_info(camera, rotation)
print({"queued": bool(unreal.AutomationLibrary.take_high_res_screenshot(1920, 1080, "AirportSecurity_centered_detector_console.png"))})
