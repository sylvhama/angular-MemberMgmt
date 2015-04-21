'use strict'

angular.module('MyApp')
.factory 'MemberMgmt', ['$rootScope', '$http', '$cookieStore', ($rootScope, $http, $cookieStore) ->

    fact = {}

    fact.createCookie = (user) ->
      $cookieStore.remove('user')
      $cookieStore.put('user', user)
      $rootScope.$broadcast('cookie_created')

    fact.doSelectUser = (user) ->
      $http.post('./php/do.php?r=selectUser'
        data: {
          facebook_id: user.facebook_id
        }
      ).success((data, status) ->
        if !data.error
          fact.createCookie(data)
        else if data.error == 'noUser'
          fact.doRegister(user)
        else
          console.log '[Error][MemberMGMT] ' + data.error
          ga('send', 'event', 'MemberMgmt Error', 'selectUser sql ', data.error)
      ).error (data, status) ->
        console.log '[Error][MemberMGMT] status: ' + status
        ga('send', 'event', 'MemberMgmt Error', 'selectUser ajax ', status)

    fact.doRegister = (user) ->
      $http.post('./php/do.php?r=register'
        data: {
          user: user
        }
      ).success((data, status) ->
        if !data.error
          fact.createCookie(user, data)
        else
          console.log '[Error][MemberMGMT] ' + data.error
          ga('send', 'event', 'MemberMgmt Error', 'register sql ', data.error)
      ).error (data, status) ->
        console.log '[Error][MemberMGMT] status: ' + status
        ga('send', 'event', 'MemberMgmt Error', 'register ajax ', status)

    fact.doUpdateShare = (user) ->
      $http.post("./php/do.php?r=updateShare"
        data: {
          user_id: user.user_id,
          facebook_id: user.facebook_id
        }
      ).success((data, status) ->
        if !data.error
          $rootScope.$broadcast("update_share", data)
        else
          console.log "[Error][MemberMGMT] " + data.error
          ga('send', 'event', 'MemberMgmt Error', 'updateShare sql ', data.error)
          $rootScope.$broadcast(network)
      ).error (data, status) ->
        console.log "[Error][MemberMGMT] " + status
        ga('send', 'event', 'MemberMgmt Error', 'updateShare ajax ', status)
        $rootScope.$broadcast(network)

    fact.doUpdateUser = (user) ->
      $http.post('./php/do.php?r=updateUser'
        data: {
          user_id: user.user_id,
          phone: user.phone,
          plane: user.plane,
          facebook_id: user.facebook_id
        }
      ).success((data, status) ->
        if !data.error
          fact.createCookie(user)
        else
          console.log '[Error][MemberMGMT] ' + data.error
          ga('send', 'event', 'MemberMgmt Error', 'updateUser sql ', data.error)
      ).error (data, status) ->
        console.log '[Error][MemberMGMT] ' + status
        ga('send', 'event', 'MemberMgmt Error', 'updateUser ajax ', status)

    return fact
  ]