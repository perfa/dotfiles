### <3 Creating A Lovely Ubuntu <3 ###


### PACKAGES!! :D ###
$development = [ 
                 "git",
                 "tig",
                 "vim",
                 "python-flake8",
                 "python-nose",
                 "python-pip",
                 "python-nosexcover",
                 "python-hamcrest",
                 "nodejs",
                 "npm",
                 "cmake",
                 "maven",
                 "expect",
                 "strongswan",
                 "strongswan-plugin-xauth-generic",
                 "tmux"
                ]
package { $development: ensure => "installed" }

$desktop = [
             "sl",
             "gnupg",
             "tree",
             "chromium-browser",
             "aptitude",
             "synaptic",
             "gimp",
             "htop",
             "gparted",
             "vlc",
             "unity-tweak-tool",
            ]
package { $desktop: ensure => "installed" }

exec { "accept-msttcorefonts-license":
    command => "/bin/sh -c \"echo ttf-mscorefonts-installer msttcorefonts/accepted-     mscorefonts-eula select true | debconf-set-selections\""
}

package { "ubuntu-extras-restricted":
    ensure  => installed,
    require => Exec['accept-msttcorefonts-license']
}

### SETTINGS!! :D ###
$home = '/home/mango'
$dotfiles = "$home/.dotfiles"
exec { "get_dotfiles":
     command => "/bin/bash -c \"cd $home && git clone https://github.com/perfa/dotfiles.git .dotfiles\"",
     creates => $dotfiles,
     }

File {
     owner => 'mango',
     group => 'mango',
     }

file { $dotfiles: }

file { "$home/bin":
     ensure => directory,
     }

file { "$home/bin/git_completion.sh":
     ensure  => link,
     target  => "$dotfiles/bin/git_completion.sh",
     require => [ File[$dotfiles], File["$home/bin"] ],
     }

file { "$home/.gitconfig":
     ensure  => link,
     target  => "$dotfiles/.gitconfig",
     require => File[$dotfiles],
     }

file { "$home/.gitignore":
     ensure  => link,
     target  => "$dotfiles/.gitignore",
     require => File[$dotfiles],
     }

file { "$home/.emacs":
     ensure  => link,
     target  => "$dotfiles/.emacs",
     require => File[$dotfiles], }

file { "$home/.emacs.d":
     ensure  => link,
     target  => "$dotfiles/.emacs.d",
     require => File[$dotfiles],
     }
file { "$home/.vim":
     ensure  => link,
     target  => "$dotfiles/.vim",
     require => File[$dotfiles],
     }

file { "$home/.vimrc":
     ensure  => link,
     target  => "$dotfiles/.vimrc",
     require => File[$dotfiles],
     }

file { "$home/.bashrc.private":
     ensure  => link,
     target  => "$dotfiles/.bashrc.private",
     require => File[$dotfiles],
     }

file_line { 'include private bash settings':
    ensure => present,
    line   => '. ~/.bashrc.private',
    path   => '/home/mango/.bashrc',
}

### Thinkpad/Lenovo Power control (TLP) and UbuntuTweak ###
# These two need some special apt lovin', as they have their own PPA's
include apt

apt::source { 'linrunner_tlp':
    location   => 'http://ppa.launchpad.net/linrunner/tlp/ubuntu',
    repos      => 'main',
    key        => {
        'id'     =>  '2042F03C5FABD0BA2CED40412B3F92F902D65EFF',
    }
}

apt::source { 'ubuntu_tweak':
    location => 'http://archive.getdeb.net/ubuntu',
    release  => 'wily-getdeb',
    repos    => 'apps',
    key      => {
         'id'      => '1958A549614CE21CFC27F4BAA8A515F046D7E7CF',
    }
}

apt::source { 'noobslab/themes':
    location => 'http://ppa.launchpad.net/noobslab/themes/ubuntu',
    repos    => 'main',
    key      => {
        'id'      => '4FA44A478284A18C1BA4A9CAD530E028F59EAE4D',
    }
}

apt::source { 'webupd8team-ubuntu-java-wily':
    location => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
    repos    => 'main',
    key      => {
        'id'     => '7B2C3B0889BF5709A105D03AC2518248EEA14886',
    }
}

$tlp_pkgs = [
             "tlp",
             "tlp-rdw",
             "tp-smapi-dkms",
             "acpi-call-tools",
            ]

package { $tlp_pkgs: 
     ensure  => installed,
     require => Apt::Source[linrunner_tlp],
     }

package { "ubuntu-tweak":
     ensure  => installed,
     require => Apt::Source[ubuntu_tweak],
     }

package { "oracle-java8-installer":
    ensure  => "installed",
    require => [ Apt::Source['webupd8team-ubuntu-java-wily'], Exec['accept-oracle-license'] ]
}

exec { "accept-oracle-license":
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections",
    path    => "/bin/",
    require => Exec[see-oracle-license]
}

exec { "see-oracle-license":
    command => "echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections",
    path    => "/bin/",
    require => Exec[see-oracle-license]
}

### Fuck unity hidey-disappeary scrollbars!!!! :D ###
exec { "/usr/bin/gsettings set com.canonical.desktop.interface scrollbar-mode normal":
    user => "mango",
}
