# Deep Learning Playground
Just some scripts and tools which I use for deep learning (with focus on object detection).

### How to train YOLO?

1. Create project folder (`data` folder, `project.names` file)
2. Annotate images with `labelImg`
3. Convert annotations to YOLO format (`convertVOC.py`)
4. Create train / test set (`create_datasets.py`)
5. Add yolo model configuration & data file
5. Run `yolo_train.py`