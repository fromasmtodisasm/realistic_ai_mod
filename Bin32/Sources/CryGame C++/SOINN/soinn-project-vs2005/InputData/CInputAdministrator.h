#ifndef _INPUT_ADMINISTRATOR_HEADER_
#define _INPUT_ADMINISTRATOR_HEADER_

#include "CVectorGenerator.h"
#include "CVectorGeneratorFromFile.h"

class CInputAdministrator
{
public:
	static const int NO_GENERATOR;
	static const int GENERATOR_FROM_FILE;
	static const int GENERATOR_SIN;
	static const int GENERATOR_GAUSSIAN;
	static const int GENERATOR_CONCENTRIC;
	static const int STATE_START;
	static const int STATE_STOP;

public:
	CInputAdministrator();
	~CInputAdministrator();
	double*	GenerateVector(void);
	bool	GetDrawCoordinates(const double *signal, double &x, double &y);
	bool	SetNoise(double noise);
	void	ResetInputNum(void);
	bool	SetGeneratorType(const int type);
	int		GetGeneratorType(void);
	bool	SetGeneratorState(const int state);
	int		GetGeneratorState(void);
	int		GetDimension(void);
	int		GetInputNum(void);
	CVectorGeneratorFromFile*	GetGeneratorFromFile(void);

private:
	CVectorGenerator*			m_pVectorGenerator;
	CVectorGeneratorFromFile*	m_pVectorGeneratorFromFile;
	int		m_generatorType;
	int		m_generatorState;
	int		m_inputNum;
	double	m_noise;
};

#endif
