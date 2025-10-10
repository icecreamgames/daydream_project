function place_platform(_x, _y, _len_tiles, _tile) {
    var i = 0;
    repeat (_len_tiles) {
        instance_create_layer(_x + i * _tile, _y, layer, obj_wall);
        i++;
    }
}
