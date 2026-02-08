#!/usr/bin/env python3
"""
Generate Audiva app icon with Spotify-inspired design
Creates a purple gradient background with white "A" letter
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_gradient(width, height, color1, color2):
    """Create a vertical gradient"""
    base = Image.new('RGB', (width, height), color1)
    top = Image.new('RGB', (width, height), color2)
    mask = Image.new('L', (width, height))
    mask_data = []
    for y in range(height):
        for x in range(width):
            mask_data.append(int(255 * (y / height)))
    mask.putdata(mask_data)
    base.paste(top, (0, 0), mask)
    return base

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple"""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def create_app_icon(output_path, size=1024, with_background=True):
    """Create the Audiva app icon"""

    # Colors from app_colors.dart
    purple_top = hex_to_rgb('#7C3AED')  # primary
    purple_bottom = hex_to_rgb('#5B21B6')  # primaryDark
    white = (255, 255, 255)
    pink = hex_to_rgb('#EC4899')  # accent

    # Create image with gradient background
    if with_background:
        img = create_gradient(size, size, purple_top, purple_bottom)
    else:
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))

    # Convert to RGBA for transparency support
    img = img.convert('RGBA')
    draw = ImageDraw.Draw(img)

    # Add rounded corners for main icon
    if with_background:
        corner_radius = int(size * 0.176)  # 18% corner radius (180px for 1024px)
        mask = Image.new('L', (size, size), 0)
        mask_draw = ImageDraw.Draw(mask)
        mask_draw.rounded_rectangle([(0, 0), (size, size)], corner_radius, fill=255)

        # Apply rounded corners
        output = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        output.paste(img, (0, 0))
        output.putalpha(mask)
        img = output
        draw = ImageDraw.Draw(img)

    # Draw the letter "A"
    # Try to use a bold system font
    font_size = int(size * 0.65)  # Large, bold letter
    try:
        # Try common bold fonts on macOS
        font_paths = [
            '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
            '/System/Library/Fonts/Helvetica.ttc',
            '/Library/Fonts/Arial Bold.ttf',
        ]
        font = None
        for font_path in font_paths:
            if os.path.exists(font_path):
                font = ImageFont.truetype(font_path, font_size)
                break

        if font is None:
            # Fallback to default font
            font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()

    # Calculate text position to center it
    text = "A"

    # Use textbbox for better positioning
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    x = (size - text_width) // 2 - bbox[0]
    y = (size - text_height) // 2 - bbox[1]

    # Draw the "A" in white
    draw.text((x, y), text, fill=white, font=font)

    # Save the image
    img.save(output_path, 'PNG')
    print(f"✓ Created: {output_path} ({size}x{size})")

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Create main app icon with background
    create_app_icon(
        os.path.join(script_dir, 'app_icon.png'),
        size=1024,
        with_background=True
    )

    # Create foreground for Android adaptive icon (no background)
    create_app_icon(
        os.path.join(script_dir, 'app_icon_foreground.png'),
        size=1024,
        with_background=False
    )

    print("\n✓ Icon generation complete!")
    print("Run: flutter pub get && dart run flutter_launcher_icons")

if __name__ == '__main__':
    main()
