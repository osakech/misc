FROM microsoft/aspnetcore:1.1
WORKDIR /app
EXPOSE 80
COPY ./publish .
#COPY ./hosting.json /
ARG dll
RUN ln -s "/app/$dll.dll" "/app/entrypoint.dll"
ENTRYPOINT ["dotnet", "entrypoint.dll"]
