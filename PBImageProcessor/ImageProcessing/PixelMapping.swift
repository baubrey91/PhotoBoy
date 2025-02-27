//
//  PixelMapping.swift
//  PixelBoy
//
//  Created by Brandon Aubrey on 2/24/25.
//


enum ColorScheme {
    case gameboyOriginal
    case gameboyPocket
    case gameboyLight
}

enum GreyScalePixelValues: UInt32 {
    
    case black = 4278190080
    case grey = 4283782485
    case lightGrey = 4289374890
    case white = 4294967295
    
    func colorCorrespondent(colorScheme: ColorScheme = .gameboyLight) -> Pixel {
        switch (self, colorScheme) {
            
            //Gameboy Light DEFAULT
        case (.black, .gameboyLight):
            return Pixel(value: 4280293384)
        case (.grey, .gameboyLight):
            return Pixel(value: 4283852852)
        case (.lightGrey, .gameboyLight):
            return Pixel(value: 4285579400)
        case (.white, .gameboyLight):
            return Pixel(value: 4291885280)
            
            // Gameboy Original
        case (.black, .gameboyOriginal):
            return Pixel(value: 1579032)
        case (.grey, .gameboyOriginal):
            return Pixel(value: 3952715)
        case (.lightGrey, .gameboyOriginal):
            return Pixel(value: 7246476)
        case (.white, .gameboyOriginal):
            return Pixel(value: 11192520)
            
            // Gameboy Pocket
        case (.black, .gameboyPocket):
            return Pixel(value: 3686446)
        case (.grey, .gameboyPocket):
            return Pixel(value: 5003328)
        case (.lightGrey, .gameboyPocket):
            return Pixel(value: 4749408)
        case (.white, .gameboyPocket):
            return Pixel(value: 2785916)
        }
    }
}
