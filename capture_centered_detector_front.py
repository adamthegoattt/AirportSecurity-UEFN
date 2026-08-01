import unreal

camera = unreal.Vector(-720.0, -1300.0, 300.0)
target = unreal.Vector(500.0, -1300.0, 270.0)
rotation = unreal.MathLibrary.find_look_at_rotation(camera, target)
unreal.EditorLevelLibrary.set_level_viewport_camera_info(camera, rotation)
print({"queued": bool(unreal.AutomationLibrary.take_high_res_screenshot(1920, 1080, "AirportSecurity_centered_detector_front.png"))})
