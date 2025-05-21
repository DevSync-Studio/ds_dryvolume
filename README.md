# Dry Volume Zones

This resource allows you to create and manage dry volume zones in your FiveM server. These zones are areas where water effects do not apply—meaning water will not affect players or objects within the defined volumes. This is useful for preventing water from flooding interiors, underground areas, or custom map locations. The script uses `ox_lib` for zone management and the native `CreateDryVolume` function to define these special areas.

## How It Works

- **Dry Volumes**: The script creates AABB (Axis-Aligned Bounding Box) volumes where water does not affect the player or environment. Only water created from drawables and collisions is affected; waterquads and other water sources are not impacted.
- **Use Cases**: Prevents water from flooding interiors, basements, or custom map areas that should remain dry, even if they are below the waterline.
- **Note**: This does not affect waterquads, only water created from drawables and collisions. Do not create dry volumes while your local ped is swimming.

## Prerequisites

- Ensure `ox_lib` is installed and started before this resource.

## Configuration

### Config.lua

The `Config.lua` file contains the configuration for the dry volume zones. You can add multiple zones by editing the `Config.zones` table. Each zone should have the following properties:

- `id`: A unique identifier for the zone.
- `points`: An array of `vec3` points defining the zone's boundaries.
- `thickness`: The thickness of the zone.

Example:

```lua
Config.zones = {
    {
        id = "apartment_pool",
        points = {
            vec3(93.300003051758, -362.14999389648, 43.0),
            vec3(76.449996948242, -362.14999389648, 43.0),
            vec3(76.400001525879, -379.0, 43.0),
            vec3(93.300003051758, -379.0, 43.0),
        },
        thickness = 85.45,
    },
    -- Add more zones here as needed
}
```

### Debug Mode

You can enable debug mode by setting `Config.debug = true` in `Config.lua`. This will print additional information about the zones, such as when a player enters or exits a zone, and details about the created dry volumes.

## Usage

1. Ensure `ox_lib` is running.
2. Start this resource.
3. The zones defined in `Config.lua` will be created automatically, and water effects will not apply within those volumes.

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details. 