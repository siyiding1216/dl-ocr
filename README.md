Run main.m to start the driver licesne recognition or create an atlas.

Require:
 1) Matlab image processing toolbox.
 2) Tesseract binary.

Step 1. Create Atlas (template).
An atlas needs to be created for each type / category of driver licenses.

An atlas contains the following data,
template image:
    a driver license picture taken in a good lighting condition
ROIs:
    a list of rectanglar regions, each for a specific character list to
    be recognized. For example, the rectangle surrounding the last name (LN)
    in california license.
foreground image:
    The parts in template image that are the unchanged parts across different
    licenses. The reason to have this is that we want to exclude any parts
    that are variant to each different person, like photo, all to be
    recognized characters.

Step 2: Landmarks detection and correspondence finding.
When a test image is provided, landmarks at image scale space are
extracted from both the template and test image.
The 64 feature vectors are also computed for these landmarks.
The Eucledean distance between these feature vectors are used to establish
point correspondence.
We then took x number of most similar point pairs.

Step 3: Landmark registration.
Once the point correspondence are established, a point registration is
done to compute a transformation that can warp the test image to the
reference image.
Affine transformation is used here since the photo could be taken potentially
at different angles.
The transformation then warp the test image to reference space where we
can apply directly the ROI coordinates to take out the parts that need to be
recognized.

Step 4. Recognize image patches using tesseract.
tesseract is called externally to recognize each image patch.
Image patch are further preprocessed with histogram equalization and
known character pattern is used as prior for tesseract to work more
accurately.
