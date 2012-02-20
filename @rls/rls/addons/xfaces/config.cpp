class CfgPatches {
    class xfaces {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.20;
    };
};

#define QUOTE(text) #text
#define FACECLASS(classname,texturefile) \
    class classname {\
        name = QUOTE($STR_##classname);\
        texture = QUOTE(\xfaces\texturefile);\
        east = 1;\
        west = 1;\
        woman = 1;\
    };

class CfgFaces {
    FACECLASS(rls_WomanFaceN1,WomanFace1.jpg)
    FACECLASS(rls_WomanFaceN1HR,WomanFace1_1024.jpg)
    FACECLASS(rls_WomanFaceN2HR,CarmenElectraBig.jpg)
};

class CfgFaceWounds {
    access=1;
    wounds[]={
        "\o\char\WomanFace1.jpg",
        "\o\char\WomanFace1.jpg",

        "\o\char\WomanFace1_1024.jpg",
        "\o\char\WomanFace1.jpg",

        "\o\char\CarmenElectraBig.jpg",
        "\o\char\CarmenElectraBig.jpg"
    };
};
