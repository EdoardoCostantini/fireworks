# Project:   fireworks
# Objective: Proces mids objects to obtain desired shape
# Author:    Edoardo Costantini
# Created:   2021-12-19
# Modified:  2021-12-19

impProcess <- function (mids_object,
                        include_0 = FALSE,
                        imp = "deafault"){

  lowi <- mice::complete(mids_object, "long", inc = include_0)

  # Compute means fo the desired outcome variables
  out <- lowi %>%
    group_by(trt) %>%
    summarise(mean_yp1 = mean(yp1, na.rm = TRUE),
              mean_yp2 = mean(yp2, na.rm = TRUE),
              mean_yp3 = mean(yp3, na.rm = TRUE),
              mean_yc1 = mean(yc1, na.rm = TRUE),
              mean_yc2 = mean(yc2, na.rm = TRUE),
              mean_yc3 = mean(yc3, na.rm = TRUE))

  # Melt them
  out <- data.frame(imp = imp, out)
  out_long <- reshape(data = out,
                      idvar = "trt",
                      varying = list(grep("yp", colnames(out)),
                                     grep("yc", colnames(out))
                      ),
                      v.names = c("yp", "yc"),
                      direction = "long")

  return(out_long)
}