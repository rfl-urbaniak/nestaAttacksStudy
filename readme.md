This repository contains data and code that accompany the paper titled 

> Whom to pity, whom to scold? Effects of empathetic and normative AI-assisted interventions
> on aggressive Reddit users with different activity profiles.

This study was supported by a grant from the NESTA Collective Intelligence Grants Programme (2019–2020) and by the National Science Center (grant no. 2021/41/B/HS1/01814).

1. The main code and explanation of how particular datasets fit into the project are available in `technical_report/nesta_study_technical_report.pdf`. If you want to compile the pdf from scratch, use the `.Rmd` file after installing all the necessary packages as specified in the preamble of that file. To be able to compile you will also need to download two folders from GoogleDrive. UPDATE: newer versions of ggplot2 break compilation, the working version is 3.4.4 and can be installed using `remotes::install_version("ggplot2", version = "3.4.4")`.

2. An additional short analysis of our experience with volunteer engagement practices can be found in `volunteers/reportVolunteers.pdf`, with the corresponding source file in `.Rmd`.


Some folders need to be downloaded separately, as they are too large to live on GitHub.

- the [data folder](https://drive.google.com/drive/folders/1C7VtUdArusuw1VLJYgXpo3m5oa0IwWTJ?usp=drive_link) After downloading, make sure that the content of the downloaded folder is identical to the content of `data/`.

- the [models folder](https://drive.google.com/drive/folders/10qhdM6Pir_o94j_DUUIUFN7mXe079y1i?usp=drive_link). After downloading, make sure that the content of the downloaded folder is identical to the content of `models/`.