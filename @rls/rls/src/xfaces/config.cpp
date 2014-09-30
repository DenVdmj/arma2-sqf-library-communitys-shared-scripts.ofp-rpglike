
class CfgPatches {
    class xfaces {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.20;
    };
};

#define __quote(text) #text
#define __wfc(classname,texturefile) \
    class classname {\
        name = __quote($STR_##classname);\
        texture = __quote(\xfaces\texturefile);\
        east = 1;\
        west = 1;\
        woman = 1;\
    };

#define __mfc(classname,texturefile) \
    class classname {\
        name = __quote($STR_##classname);\
        texture = __quote(\xfaces\texturefile);\
        east = 1;\
        west = 1;\
        woman = 0;\
    };



class CfgFaces {

    __wfc(rls_face_female_2,electra.jpg)
    __wfc(rls_face_female_1,girl1.jpg)

    __wfc(rls_face_angelina,3thP_fem_angelina.jpg)
    __wfc(rls_face_audrey,3thP_fem_audrey.jpg)
    __wfc(rls_face_carrie,3thP_fem_carrie.jpg)
    __wfc(rls_face_cynthia,3thP_fem_cynthia.jpg)
    __wfc(rls_face_dushku,3thP_fem_dushku.jpg)
    __wfc(rls_face_gillian,3thP_fem_gillian.jpg)
    __wfc(rls_face_heather,3thP_fem_heather.jpg)
    __wfc(rls_face_hedy,3thP_fem_hedy.jpg)
    __wfc(rls_face_holly,3thP_fem_holly.jpg)
    __wfc(rls_face_jennifer,3thP_fem_jennifer.jpg)
    __wfc(rls_face_kate,3thP_fem_kate.jpg)
    __wfc(rls_face_keira,3thP_fem_keira.jpg)
    __wfc(rls_face_kimberley,3thP_fem_kimberley.jpg)
    __wfc(rls_face_kristin,3thP_fem_kristin.jpg)
    __wfc(rls_face_lucy,3thP_fem_lucy.jpg)
    __wfc(rls_face_marcell,3thP_fem_marcell.jpg)
    __wfc(rls_face_mena,3thP_fem_mena.jpg)
    __wfc(rls_face_monica,3thP_fem_monica.jpg)
    __wfc(rls_face_natalie,3thP_fem_natalie.jpg)
    __wfc(rls_face_pla,3thP_fem_pla.jpg)
    __wfc(rls_face_swede,3thP_fem_swede.jpg)
    __wfc(rls_face_swede02,3thP_fem_swede02.jpg)

    __mfc(rls_face_men_p1,3thP_men_p1.jpg)
    __mfc(rls_face_men_p1a,3thP_men_p1a.jpg)
    __mfc(rls_face_men_p3,3thP_men_p3.jpg)
    __mfc(rls_face_men_p4,3thP_men_p4.jpg)
    __mfc(rls_face_men_p6,3thP_men_p6.jpg)
    __mfc(rls_face_men_p9,3thP_men_p9.jpg)
    __mfc(rls_face_men_p11,3thP_men_p11.jpg)
    __mfc(rls_face_men_p12,3thP_men_p12.jpg)
    __mfc(rls_face_men_p13,3thP_men_p13.jpg)
    __mfc(rls_face_men_p17,3thP_men_p17.jpg)
    __mfc(rls_face_men_p18,3thP_men_p18.jpg)
    __mfc(rls_face_men_terry,tex_terry.jpg)

};
/*
class CfgFaceWounds {
    access=1;
    wounds[]={
        "electra.jpg",
        "electra_wounded.jpg",
        "girl1.jpg",
        "girl1.jpg"
    };
};
*/