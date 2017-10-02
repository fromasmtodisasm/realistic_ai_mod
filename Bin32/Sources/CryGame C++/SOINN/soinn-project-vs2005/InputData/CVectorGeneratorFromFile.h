#ifndef _VECTOR_GENERATOR_FROM_FILE_
#define _VECTOR_GENERATOR_FROM_FILE_

#include "CVectorGenerator.h"
#include <windows.h>

class CVectorGeneratorFromFile : public CVectorGenerator
{
public:
	CVectorGeneratorFromFile();
	double*	GenerateVector(void);
	bool	GetDrawCoordinates(const double *signal, double &x, double &y);
	bool	ReadVectorFile(const char *fileName);
	bool	Clear(void);
	char*	GetClassName(const int targetClass);
	int		GetClassSize(const int targetClass);
	double*	GetClassData(const int targetClass, const int targetData);
	int		GetClassID(const double *signal);
	bool	GetGenerateState(const int targetClass);
	bool	SetGenerateState(const int targetClass, const bool generate=true);

private:
	double	Distance(const double *signal1, const double *signal2);

private:
	struct sClassData
	{
		char	*name;
		int		size;
		double	**data;
		bool	generate;
	};
	struct sClassData* m_classData;
	bool	m_loaded;
	double*	m_transrateMatrix[2];
	bool*	m_generateState;
	int		m_generateClassNum;
	int		*m_generateClass;

public:
	static const int ALL_CLASS/*=-1*/;
};

#endif
