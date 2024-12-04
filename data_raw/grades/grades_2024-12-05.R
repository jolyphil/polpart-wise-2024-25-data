name <- c("Emilia", "Hannah", "Mia", "Matteo", "Noah")
grade <- c(2.3, 1.0, 3.0, 2.7, 1.3)
desc <- c("good", "very good", "satisfactory", "satisfactory", "very good")

grades <- data.frame(name, grade, desc)

saveRDS(grades, file = "data/2024-12-05_grades.rds")
