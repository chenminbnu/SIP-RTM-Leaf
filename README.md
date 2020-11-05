# SIP-RTM-Leaf
## Model Description
    A leaf spectrum model that simulates leaf reflectance, transmittance and single scattering albedo with inputs of chlorophyll content, equivalent water thickness, dry matter content etc.
    The model is built following the spectral invariants theory, using two wavelength-independent leaf structural parameters, i.e., two spectrally invariant parameters (a photon recollision probability p and a scattering asymmetry parameter  q) to describe the leaf-scale radiatve transferring process.
    Detailed descriptions can be found in Wu S.,Zeng Y.,Hao D.,Liu Q.,Li J., Chen X.,R.Asrar G.,Yin G., Wen J., Yang B., Zhu P.,Chen M.,2020.Quantifying leaf optical properties with spectral invariants theory. DOI: https://doi.org/10.1016/j.rse.2020.112131


## File Description
    1. Please start with the SIP_Main.m, which is the main function and can display the output figures.  
    2. leaf_parameter.txt is the input parameters, and the description of the order of input is in SIP_Main.m. You can also provide the input in SIP_Main.m after slightly changing the code.  
    3. leaf_spectrum.txt is the output, and the order is [wavelength, leaf single scattering albedo, leaf reflectance, leaf transmittance].  
    4. The key code of the SIP model is in SIP_Model.m, which only has a few lines in addition to the description of the input parameters.   
    5. dataSpec_PDB.m and calctav.m are about the specific absorption coefficient of leaf biochemical constituents, which do not need the users to be quite familiar with. 
