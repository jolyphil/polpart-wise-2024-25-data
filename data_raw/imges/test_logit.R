library(marginaleffects)
library(modelsummary)

fit <- glm(turnout ~ 
             gender +
             age +
             age2 +
             edu +
             income +
             west +
             cohabit +
             orgmem +
             satdem +
             partyid +
             polinter +
             efficacy +
             soctrust, 
           data = imges, 
           family = binomial)

options(scipen=999)

cm <- c('gender' = 'Gender',
        'age' = 'Age',
        'age2' = 'Age squared',
        'edu' = 'Education',
        'income' = 'Income log',
        'west' = 'Origin: West Germany',
        'cohabit' = 'Parnership',
        'orgmem' = 'Organisation member',
        'satdem' = 'Satisfaction: Democracy',
        'partyid' = 'Party identification',
        'poliner' = 'Political interest',
        'efficacy' = 'Internal political efficacy')

modelsummary(avg_slopes(fit), 
             stars = TRUE, shape = term + contrast ~ model,
             coef_map = cm,
             fmt = 2)
