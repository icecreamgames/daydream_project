/// obj_acid_controller — Clean Up (safe)
if (variable_instance_exists(id, "flood_prog")) {
    if (ds_exists(flood_prog, ds_type_grid)) ds_grid_destroy(flood_prog);
}
if (variable_instance_exists(id, "flood_tstart")) {
    if (ds_exists(flood_tstart, ds_type_grid)) ds_grid_destroy(flood_tstart);
}
if (variable_instance_exists(id, "flood_dir")) {
    if (ds_exists(flood_dir, ds_type_grid)) ds_grid_destroy(flood_dir);
}
if (variable_instance_exists(id, "frontier")) {
    if (ds_exists(frontier, ds_type_list)) ds_list_destroy(frontier);
}
