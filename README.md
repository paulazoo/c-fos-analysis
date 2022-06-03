# histology (c-Fos and TH+) analysis with cellpose
Written in matlab by paula zhu

- crop to relevant brain regions with batch_crop
- mark tissue regions for analysis with make_tissuemask
- combined two cFos cellpose outputs with cFos_cp_combine
- edit cellpose output rois with mask_roi_editor
- create anatomical sections with make_grid
- apply grid sections and count cells in each section with apply_grid
- aggregate cellcounts in each grid section with read_cellcount_data
