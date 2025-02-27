#  PixelBoy
Photo processing app that lets you import images and turns them into "8-Bit Style" graphics

## Features
- Import images
- Adjust contrast
- Adjust brightness
- Save to photo librar
- Share
- Unit Tests
- Editible colors (hard coded cannot be done in app)

## Processing
The image processing is done in three steps 
1. Crop the image to have a 160 x 144 ratio
2. Reduce the image to a planar2 grayscale ie each pixel holds 2 bits which is 4 colors. Here we also need to dither which is build into the Accelerate Framework
3. Iterate through each pixel and map the gray value to a green value


## Sample 
| Home | Imported | Processed|
|------|------|------|
|![Simulator Screenshot - iPhone 16 Pro - 2025-02-27 at 10 27 38](https://github.com/user-attachments/assets/896e91a4-6409-43f4-bd7a-6b469ffb9006)|![Simulator Screenshot - iPhone 16 Pro - 2025-02-27 at 10 27 47](https://github.com/user-attachments/assets/c367888f-6bc0-47e5-9171-56dc48179f05)|![Simulator Screenshot - iPhone 16 Pro - 2025-02-27 at 10 28 17](https://github.com/user-attachments/assets/ace1a433-f765-4313-8eda-d3103a9d9c49)|


##  Alternative Colors
| GBOrignal | GBPocket |
|------|------|
|![Simulator Screenshot - iPhone 16 Pro - 2025-02-27 at 10 31 12](https://github.com/user-attachments/assets/38aa387d-30f7-41ba-bccc-f8c6d52e42cf)|![Simulator Screenshot - iPhone 16 Pro - 2025-02-27 at 10 31 57](https://github.com/user-attachments/assets/1d5ef5ac-8436-4944-b9b8-705d57e2a684)|


## Other
| Splash Screenn| Error Screen|
|------|------|
|![Simulator Screenshot - iPhone 16 Pro - 2025-02-27 at 10 37 01](https://github.com/user-attachments/assets/e218051c-f8cb-4473-8d20-cfbac6574eb3)|![Simulator Screenshot - iPhone 16 Pro - 2025-02-27 at 10 37 04](https://github.com/user-attachments/assets/5d01e27b-79b8-4459-921c-e262b095add6)|


## Style 
Follows Rey Wenderlich style guide https://github.com/raywenderlich/swift-style-guide

## Credited Work
Inspiration from 
- https://www.youtube.com/watch?v=jQTByAUF7X4 (web application version)
- https://www.youtube.com/watch?v=WtoSiYYQXQQ (swiftui)
