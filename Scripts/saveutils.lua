----------------------------------------------------------------------------
CI_NEWTABLE=1
CI_ENDTABLE=2
CI_STRING=3
CI_NUMBER=4


function WriteIndex(stm,idx)
	if(type(idx)=="number")then
		stm:WriteBool(1);
		stm:WriteInt(idx);
	elseif(type(idx)=="string")then
		stm:WriteBool(nil);
		stm:WriteString(idx);
	else
		System:Log("Unrecognized idx type");
	end
end

function ReadIndex(stm)
	local bNumber=stm:ReadBool();
	if(bNumber)then
		return stm:ReadInt();
	else
		return stm:ReadString();
	end
end

function WriteToStream(stm,t,name)
	if(name==nil)then
		name="__root__"
	end
	if(type(t)=="table")then
		stm:WriteByte(CI_NEWTABLE);
		WriteIndex(stm,name);
		for i,val in t do
			WriteToStream(stm,val,i);
		end
		stm:WriteByte(CI_ENDTABLE);
	else
		local tt=type(t);
		if(tt=="string")then
			stm:WriteByte(CI_STRING);
			WriteIndex(stm,name);
			stm:WriteString(t);
			--System:Log("STRING "..name.." "..t);
		elseif(tt=="number")then
			stm:WriteByte(CI_NUMBER);
			WriteIndex(stm,name);
			stm:WriteFloat(t);
			--System:Log("NUMBER "..name.." "..t);
		end
	end
end

function ReadFromStream(stm,parent)
	local chunkid=stm:ReadByte();
	local idx=nil;
	local val;
	if(chunkid~=CI_ENDTABLE)then
		idx=ReadIndex(stm);
		if(chunkid==CI_NEWTABLE)then
		------------------------------
			val={}
			while(ReadFromStream(stm,val)~=CI_ENDTABLE)do end
			if(parent)then
				parent[idx]=val;
			end
		------------------------------
		elseif (chunkid==CI_STRING)then
			parent[idx]=stm:ReadString();
		elseif (chunkid==CI_NUMBER)then
			parent[idx]=stm:ReadFloat();
		end
	end

	if(parent==nil)then
		return val;
	else
		return chunkid;
	end
end

--WriteToStream(ProximityTrigger);
--table=ReadFromStream(stm)