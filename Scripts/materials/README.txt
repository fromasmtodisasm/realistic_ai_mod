-----------------------------------------------------------------
Notes, tips, info about materials
***** please update when you add stuff! *******


--FILENAMES AND WHAT THEY MEAN--

filenames with '_nd' mean 'No Decals'
filenames with '_p' mean 'Piercible' 

materials like grass, water etc. will not have the '_p' in their 
filename. Mostly used for things like 'metal sheet'



--SCRIPT SYNTAX---
gameplay_physic = {
	piercing_resistence = nil,
}

piercing_resistence = nil
same as
piercing_resistence = 0
Shoot through material. Removing 'piercing_resistence' is the 
same result.

piercing_resistence = 7
material is pirsable for bullets, but not for particle physics ( greandes )

piercing_resistence = 15
material is not piersable. You can NOT shoot through this surface, particle physics will not pass through it


gameplay_physic = {
	friction = 1.5,
}

friction = nil will mean entities (NOT THE PLAYER) will slide over 
this surface.

friction = 1 will mean enities (NOT THE PLAYER) will start to 
slide at 45

A friction value greater than 1 will mean enities (NOT THE PLAYER) 
will start to slide at angles greater than 45. For example, a 1.5
value means at angle 56.7)



